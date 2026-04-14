module dff_async_rst(
    input clk, rst, d, en,
    output reg q
);

always @(posedge clk, negedge rst) begin
    if(!rst) begin
        q <= 1'b0;
    end else if(en) begin
        q <= d;
    end
end

endmodule