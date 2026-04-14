module loadable_counter (CLK, RST, EN, LOAD, D, Q);
input CLK, RST, EN, LOAD;
input [9:0] D;
output reg [9:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 10'b0;
    end
    else if (LOAD) begin
        Q <= D;
    end
    else if (EN) begin
        Q <= Q + 1;
    end
end

endmodule