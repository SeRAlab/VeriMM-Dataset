module down_counter_4bit (
    input wire clk,
    input wire reset,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 4'b1111;
    end else begin
        if (count == 4'b0000) begin
            count <= 4'b1111;
        end else begin
            count <= count - 1;
        end
    end
end

endmodule