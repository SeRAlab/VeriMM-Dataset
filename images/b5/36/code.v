module lfsr(
    input clk,
    input reset,
    
    output reg [5:0] q
);

wire feedback = q[5] ^ q[4];

always @(posedge clk) begin
    if (reset) begin
        q <= 6'b000001;
    end else begin
        q <= {q[4:0], feedback};
    end
end

endmodule