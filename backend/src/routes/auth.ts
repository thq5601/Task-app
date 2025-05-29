import { Router } from "express";

const authRouter = Router()

authRouter.get('/', (req, res) => {
    res.send('Auth page')
})

export default authRouter
