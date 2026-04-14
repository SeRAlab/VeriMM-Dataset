module shift_register (CLK, SI, RST, Q);
input CLK, SI, RST;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 8'b00000000;
    end
    else begin
        Q <= {Q[6:0], SI};
    end
end

endmodule