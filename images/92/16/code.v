module up_down_counter (
    input clk,
    input reset,
    input en,
    input load,
    input dir,
    input [15:0] load_val,
    output reg [15:0] q);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 16'b0000000000000000;
    else if (load)
        q <= load_val;
    else if (en) begin
        if (dir)
            q <= q + 1;
        else
            q <= q - 1;
    end
end

endmodule