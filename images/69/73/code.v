module johnson_counter(
    input               clk,
    input               clr,

    output reg [4:0]    count
);

always@(posedge clk or posedge clr) begin
    if (clr)
        count <= 5'b00000;
    else
        count <= {count[3:0], ~count[4]};
end

endmodule