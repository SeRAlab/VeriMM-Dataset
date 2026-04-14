module down_counter(
    input clk,
    input rst,
    input en,

    output reg [2:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        count <= 3'b111;    // reset to 7
    else if (en)
        count <= count - 1; // decrement
end

endmodule