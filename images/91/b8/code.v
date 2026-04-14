module top_module(RF_WE, DM_WE, Q6, Q10,reset, clk);input[5:0] Q6, Q10;

    input reset, clk;
    output RF_WE, DM_WE;
    

    wire[5:0] D10;
    
    reg[31:0] Q13;
    reg RF_WE, DM_WE;

    always @*
    begin
        if(reset == 1) begin
            RF_WE <= 0;
            DM_WE <= 0;
        end
        else begin
            if(reset == 0) begin
                case(Q6)
                    0: DM_WE <= 0; 
                    3: DM_WE <= 1; 
                    default: DM_WE <= 0; 
                endcase
                case(Q10)
                    0: RF_WE <= 0; 
                    1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 23, 24: RF_WE <= 1;
                    default: RF_WE <= 0; 
                endcase
            end
        end
    end

endmodule