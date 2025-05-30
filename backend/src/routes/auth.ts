import { Request, Response, Router } from "express";
import { db } from "../db";
import { NewUser, users } from "../db/schema";
import { eq } from "drizzle-orm";
import bcryptjs from "bcryptjs"


const authRouter = Router()

interface SignUpBody {
    name: string
    email: string
    password: string
}

authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
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
        const hashedPassword = await bcryptjs.hash(password, 8)

        // create a new user and store it in DB
        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword
        }

        const [user] = await db.insert(users).values(newUser).returning()
        res.status(201).json(user)  // return status 201 if user created
    }
    catch (e) {
        res.status(500).json({ error: e })
    }
})

authRouter.get('/', (req, res) => {
    res.send('Auth page')
})

export default authRouter
