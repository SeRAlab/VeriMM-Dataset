module ring_counter_3bit (CLK, RST, Q);
input CLK, RST;
output reg [2:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 3'b001;
    end else begin
        Q <= {Q[1:0], Q[2]};
    end
end

endmodule