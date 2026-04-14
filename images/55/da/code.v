module lfsr (
    input clk,
    input reset,
    input en,
    output reg [4:0] q);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 5'b00001;
    else if (en) begin
        q <= {q[3:0], q[4] ^ q[2]};
    end
end

endmodule