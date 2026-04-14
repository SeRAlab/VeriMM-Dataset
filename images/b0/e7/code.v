module sync_binary_counter (CLK, RESET, Q);
input CLK;
input RESET;
output reg [3:0] Q;

always @(posedge CLK) begin
    if (RESET) begin
        Q <= 4'b0000;
    end
    else begin
        Q <= Q + 1;
    end
end

endmodule