module binary_up_counter(
    input           clk  ,
    input           clr  ,
    input           en   ,

    output reg [3:0] count
);

always @(posedge clk or posedge clr) begin
    if (clr) begin
        count <= 0;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule