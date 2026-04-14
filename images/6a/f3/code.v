module up_down_counter (
    input clk,
    input rst_n,
    input en,
    input dir,
    output reg [9:0] count
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 10'b0000000000;
    else if (en) begin
        if (dir)
            count <= count + 1;
        else
            count <= count - 1;
    end
end

endmodule