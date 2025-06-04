import { Request, Response, Router } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs";
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from "../middleware/auth";


const authRouter = Router()

interface SignUpBody {
    name: string
    email: string
    password: string
}

interface LoginBody {
    email: string
    password: string
}

// sign up section
authRouter.post(
    "/signup", 
    async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // get req body
        const { name, email, password } = req.body
        // check if the user already exist
        const existingUser = await db
            .select()
            .from(users)
            .where(eq(users.email, email))  // select all from users where users.email equal to email

        if(existingUser.length){
            // if no existingUser in the db, existingUser.length = 0 
            // if(0) as same as if(false) so the if condition will never run
            res
                .status(400)
                .json({msg: "Same email already exist!"})
            return
        }

        // hashed password
        const hashedPassword = await bcryptjs.hash(
            password, 
            8
        )

        // create a new user and store it in DB
        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword
        }

        const [user] = await db.insert(users).values(newUser).returning()
        res.json(user)  // return if user created
    }
    catch (e) {
        res.status(500).json({ error: e })
    }
})

// login section
authRouter.post(
    "/login", 
    async (req: Request<{}, {}, LoginBody>, res: Response) => {
    try {
        // get req body
        const { email, password } = req.body
        // check if the user doesn't exist
        const [existingUser] = await db
            .select()
            .from(users)
            .where(eq(users.email, email))  // select all from users where users.email equal to email

        if(!existingUser){
            // check if the user doesn't exist
            res
                .status(400)
                .json({msg: "User with this email does not exist!"})
            return
        }

        // compare the password to check if it true or false
        const isMatch = await bcryptjs.compare(
            password, 
            existingUser.password
        )

        if (!isMatch){
            res.status(400).json({msg: "Incorrect password!"})
            return
        }

        const token = jwt.sign({id: existingUser.id}, "passwordKey")

        res.json({token, ...existingUser})  // return if login succesful
    }
    catch (e) {
        res.status(500).json({ error: e })
    }
})

// 
authRouter.post(
    "/tokenIsValid",
    async(req, res)=>{
        try{
            // get the header
            const token = req.header("x-auth-token")

            if(!token){
                res.json(false)
                return 
            }

            // verify if the token is valid
            const isVerified = jwt.verify(token, "passwordKey")

            if(!isVerified){
                res.json(false)
                return 
            }

            // get the user data if the token is valid
            const verifiedToken = isVerified as {id: string}

            const user = await db
                .select()
                .from(users)
                .where(eq(users.id, verifiedToken.id))
            
            // if no user, return false
            if (!user){
                res.json(false)
                return
            }

            res.json(true)
        }
        catch(e){
            res.status(500).json(false)
        }
    }
)

authRouter.get(
    "/", 
    auth, 
    async (req: AuthRequest, res) => {
        try{
            if(!req.user){
                res.status(401).json({msg: "User not found!"})
                return
            }

            const [user] = await db.select().from(users).where(eq(users.id, req.user))

            res.json({
                ...user,
                token: req.token
            })
        }
        catch(e){
            res.status(500).json(false)
        }
})

export default authRouter
