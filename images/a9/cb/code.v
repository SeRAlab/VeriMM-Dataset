module shift_register(CLK, RST, SI, Q);
input CLK, RST, SI;
output reg [7:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) 
        Q <= 8'b00000000;
    else 
        Q <= {SI, Q[7:1]};
end

endmodule