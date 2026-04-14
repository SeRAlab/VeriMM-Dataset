module top_module(
        input   [5:0] i_op,
        output  [3:0] o_op
);assign o_op = (i_op[5:4] == 2'b00) ? 4'b0010 :  
                (i_op[5:4] == 2'b01) ? 4'b0110 :        
                (i_op[3] == 1'b1) ? 4'b0110 :   
                (i_op[2:0] == 3'b000) ? 4'b0010 :       
                (i_op[2:0] == 3'b111) ? 4'b0000 :       
                (i_op[2:0] == 3'b110) ? 4'b0001 : 4'b0;         

endmodule