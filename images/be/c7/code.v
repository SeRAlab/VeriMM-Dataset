module top_module(dm_out, alu_out, MemtoReg, mux3_out);input       [31:0] dm_out;      
    input       [31:0] alu_out;     
    input              MemtoReg;    
    output reg  [31:0] mux3_out;   

    always @(*)
        if (MemtoReg)
            mux3_out <= dm_out;
        else
            mux3_out <= alu_out;endmodule