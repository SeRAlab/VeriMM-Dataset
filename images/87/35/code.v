module shift_register(CLK, LOAD, DATA_IN, Q);
input CLK, LOAD;
input [3:0] DATA_IN;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (LOAD)
        Q <= DATA_IN;
    else
        Q <= {Q[2:0], 1'b0}; // Shift left
end

endmodule