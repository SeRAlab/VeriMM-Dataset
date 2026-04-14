module shift_register(CLK, RST, EN, LOAD, DATA_IN, Q);
input CLK, RST, EN, LOAD;
input [3:0] DATA_IN;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (RST)
        Q <= 4'b0000;
    else if (LOAD)
        Q <= DATA_IN;
    else if (EN)
        Q <= {1'b0, Q[3:1]};
end

endmodule