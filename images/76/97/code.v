module top_module(SH_DIR,SH_AMT,D_IN,D_OUT);input SH_DIR;
    input [4:0]SH_AMT;
    input [31:0]D_IN;
    output reg[31:0]D_OUT;


    always @(SH_DIR,SH_AMT,D_IN)
        begin
            if(SH_AMT[2]==1)
            begin
                if(SH_DIR==1'b1)    
                    begin
                        D_OUT[27:0] <= D_IN[31:4];
                        D_OUT[31:28] <= {4{D_IN[31]}};
                    end
                else                
                    begin
                        D_OUT[31:4]<=D_IN[27:0];
                        D_OUT[3:0]<={4{1'b0}};
                    end
            end
            else
                D_OUT<=D_IN;
        end
endmodule