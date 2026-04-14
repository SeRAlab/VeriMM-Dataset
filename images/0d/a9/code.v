module divide_by_8_counter (
    input clk,
    input reset,
    output reg [2:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 3'b000;
    end else begin
        count <= count + 1;
    end
end

endmodule