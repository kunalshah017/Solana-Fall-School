use anchor_lang::prelude::*;

declare_id!("6AKMTkh7DEBfQhZgWDhpejMy4JBJjmTQuvZsKrnxpjt2");

#[program]
pub mod hello_solana {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
