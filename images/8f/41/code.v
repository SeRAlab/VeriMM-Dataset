module top_module(
    input CLK,
    input [2:0] BRANCH_OP,
    input [1:0] LOAD,
    input BIT,
    input ZIn,
	input FIn,
    input [1:0] STATIN,

    output [1:0] STAT,
    output BRANCH
    );reg Z = 0;
    reg F = 0;
    
    assign STAT = {F, Z};

    assign BRANCH = (BRANCH_OP == 2) ?  Z      : 
                    (BRANCH_OP == 3) ? !Z      : 
                    (BRANCH_OP == 4) ? !Z &  F : 
                    (BRANCH_OP == 5) ? !Z & !F : 
                    (BRANCH_OP == 6) ?  Z |  F : 
                    (BRANCH_OP == 7) ?  Z | !F : 
                                       1'd1;

    always @ (posedge CLK) begin
        casex (LOAD)
        2'b01: begin
            Z <= ZIn;
            F <= FIn;
            end
        2'b10: begin
            Z <= !BIT;
            F <= 0;
            end
        2'b11: begin
            Z <= STATIN[0];
            F <= STATIN[1];
            end
        endcase
    end

endmodule