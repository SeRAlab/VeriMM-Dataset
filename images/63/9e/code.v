module top_module(imm, e_out);input [15:0] imm;
    output reg [31:0] e_out;
    
    always @(*) begin
        if (imm[15] == 0) begin
            e_out <= {16'h0000, imm};
        end
        else begin
            e_out <= {16'hFFFF, imm};
        end
    end
endmodule