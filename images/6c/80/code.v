module down_counter_4bit (
    input      clk,
    input      rst,
    input      en,
    output reg [3:0] count
);always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b1111;
    else if (en)
        count <= count - 1;
end

endmodule