import { UUID } from "crypto";
import { NextFunction, Request, Response } from "express";
import jwt from "jsonwebtoken"
import { db } from "../db";
import { users } from "../db/schema";
import { eq } from "drizzle-orm";

export interface AuthRequest extends Request{
    user?: UUID
    token?: string
}

export const auth = async (
    req: AuthRequest, 
    res: Response, 
    next: NextFunction)=>{
        try {
            // get the header
            const token = req.header("x-auth-token")

            if(!token){
                res.status(401).json({msg: "No auth token, access denied!"})
                return 
            }

            // verify if the token is valid
            const isVerified = jwt.verify(token, "passwordKey")

            if(!isVerified){
                res.status(401).json({msg: "Token verification failed!"})
                return 
            }

            // get the user data if the token is valid
            const verifiedToken = isVerified as {id: UUID}

            const user = await db
                .select()
                .from(users)
                .where(eq(users.id, verifiedToken.id))
            
            // if no user, return false
            if (!user){
                res.status(401).json({msg: "User not found!"})
                return
            }

            req.user = verifiedToken.id
            req.token = token

            next() 
            }
        catch(e){
            res.status(500).json(false)
        }
    }