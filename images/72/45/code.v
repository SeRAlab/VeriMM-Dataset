module shift_register_8bit (D, CLK, LOAD, SHIFT, Q);
input [7:0] D;
input CLK, LOAD, SHIFT;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (LOAD) begin
        Q <= D;
    end
    else if (SHIFT) begin
        Q <= Q << 1;
    end
end

endmodule