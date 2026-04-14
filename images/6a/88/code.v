module binary_counter(
    input            clk  ,
    input            rstn ,

    output reg [3:0] count
);

always @(posedge clk or negedge rstn)
begin
    if (!rstn)       count <= 0;
    else if (count == 4'b1111) count <= 0;
    else              count <= count + 1;
end

endmodule