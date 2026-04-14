module up_counter_3bit(
    input clk,
    input reset,

    output reg [2:0] count
);

// Counter logic
always @(posedge clk or posedge reset)
begin
    if (reset)
        count <= 3'b000;
    else
        count <= count + 1;
end

endmodule