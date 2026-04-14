module down_counter (
    input wire clk,
    input wire reset,
    input wire [3:0] start_value,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= start_value;
    end else if (count > 0) begin
        count <= count - 1;
    end else begin
        count <= start_value;
    end
end

endmodule