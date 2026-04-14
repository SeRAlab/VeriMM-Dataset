module ring_counter (CLK, RST, Q);
input CLK, RST;
output reg [11:0] Q;

always @(posedge CLK) begin
    if (RST) begin
        Q <= 12'b000000000001;
    end
    else begin
        Q <= {Q[10:0], Q[11]};
    end
end

endmodule