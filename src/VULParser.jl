module VULParser

    using CSV
    using DataFrames

    function VUL(df)

        f = open(df);

        lines = readlines(f)
        lines = lines[38:270184]
        
        
        # Minors ------------------------------------------------------------------
        
        minors = ["FPMN", "PTI", "FCWN", "PRBN", "FRBN",
                    "PAGN", "CUST", "FAGN", "FCM", "FFH",
                    "GL", "PPMN", "PCAG", "FCWD", "FLMR",
                    "RS", "PCPM", "HIGH", "FLAG", "FCSR",
                    "MAST", "FFI", "PPBN", "FPBN", "PCPB",
                    "PCRL", "FTI", "FLPM", "CUSL", "FLSC",
                    "PFH", "FMRP", "HIGN", "FLRL", "INVN",
                    "PFRB", "FLPB", "PCSR", "FFRB", "FRLN"]
        
        # Find cust starts --------------------------------------------------------
        
        cust_starts = []
        
        for line in lines
            ans = "false"
            for minor in minors
                try
                    z = occursin(minor, line[22:27])
                    if z == true
                        ans = "true"
                    end
                catch
                end
            end
            push!(cust_starts, ans)
        end
        
        cust_starts = findall(x -> x == "true", cust_starts)
        
        
        # Fn to pull customer data ------------------------------------------------
        
        function getData(index)
        
            # index = 80171
            # index = cust_starts[7941]
            ending = index + 3
        
            chunk = lines[index:ending]
            names = []
            for line in chunk
                try
                    z = line[1:22]  
                    push!(names, z)
                    # println(index)
                catch
                    # println("erririririri")
                end
            end
                
            
            
            meat = []
            for line in chunk
                try
                    z = line[23:end]
                    push!(meat, z)
                catch
                    # println("whaa")
                end
                # println(z)
                
            end
        
            name = names[1]
            account_number = names[2]
            int_rate = meat[1][13:20]
            cont_date = meat[1][23:33]
            orig_amount = meat[1][35:49]
            accr_int = meat[1][51:64]
            due_date = meat[1][66:76]
            rate_type = meat[2][10:20]
            prin_bal = meat[2][34:49]
            owned_amt = meat[2][99:113]
            ytd_int = meat[3][34:49]
            sold_amt = meat[3][99:113]
            credit_limit = "0"
            avail_credit = "0"
            try
                credit_limit = meat[4][13:27]
                avail_credit = meat[4][50:64]
            catch
            end
        
        
            df = DataFrame(account_number = account_number,
             int_rate = int_rate,
             cont_date = cont_date,
             orig_amount = orig_amount,
             accr_int = accr_int,
             due_date = due_date,
             rate_type = rate_type,
             prin_bal = prin_bal,
             owned_amt = owned_amt,
             ytd_int = ytd_int,
             sold_amt = sold_amt,
             credit_limit = credit_limit,
             avail_credit = avail_credit
             )
        
             return(df)
        end
        
        # Run main fn -------------------------------------------------------------
        
        df_array = []
        for i in cust_starts
            foo = getData(i)
            push!(df_array, foo)
            # try
            #     foo = getData(i)
            #     push!(df_array, foo)
            # catch
            # end
        end
        
        
        # Concat array of dataframes into 1 dataframe -----------------------------
        
        final_df = DataFrame()
        
        for i in df_array
            append!(final_df, i)
        end
        

        return(final_df)

    end

end # module
