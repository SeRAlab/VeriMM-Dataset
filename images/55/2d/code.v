module shift_reg_4bit (SI, CLK, RESET, Q);
input SI;
input CLK;
input RESET;
output reg [3:0] Q;

always @(posedge CLK or posedge RESET) begin
    if (RESET) begin
        Q <= 4'b0000;
    end
    else begin
        Q <= {Q[2:0], SI};
    end
end

endmodule