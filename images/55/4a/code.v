module johnson_counter_4bit (CLK, RST, Q);
input CLK, RST;
output reg [3:0] Q;

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 4'b0000;
    end else begin
        Q <= {~Q[0], Q[3:1]};
    end
end

endmodule