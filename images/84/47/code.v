module loadable_counter (CLK, RST, LOAD, D, Q);
input CLK, RST, LOAD;
input [3:0] D;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else if (LOAD) begin
        Q <= D;
    end else begin
        Q <= Q + 1;
    end
end

endmodule