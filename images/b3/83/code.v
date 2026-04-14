module d_flip_flop(    
    input clk,
    input rst,
    input d,
    output reg q
);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 1'b0; // reset to 0
    else
        q <= d; // capture data
end

endmodule