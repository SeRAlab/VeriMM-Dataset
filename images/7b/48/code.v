module counter3bit (
    input clk,
    input up_down,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (up_down) begin
        count <= count + 1;
    end else begin
        count <= count - 1;
    end
end

endmodule