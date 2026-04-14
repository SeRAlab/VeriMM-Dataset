module shift_reg_4bit (CLK, RST, SI, Q);
input CLK, RST, SI;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        Q <= {SI, Q[3:1]};
    end
end

endmodule