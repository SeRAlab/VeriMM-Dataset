module shift_reg_4bit(CLK, LOAD, DATA_IN, SHIFT_IN, Q);
input CLK, LOAD;
input [3:0] DATA_IN;
input SHIFT_IN;
output [3:0] Q;
reg [3:0] Q;

always@(posedge CLK) begin
    if (LOAD)
        Q <= DATA_IN;
    else
        Q <= {SHIFT_IN, Q[3:1]};
end

endmodule