module up_counter(
    input clk, rst, en, load,
    input [3:0] load_val,
    output reg [3:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        count <= 4'b0;
    else if (en)
        count <= count + 4'b1;
    else if (load)
        count <= load_val;
end

endmodule