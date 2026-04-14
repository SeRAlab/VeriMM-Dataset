module top_module(
    input wire clk,
    input wire reset,
    input wire [15:0] data,
    output wire [15:0] result,
    output wire greater_than_32767
);reg [15:0] shift_reg;
    wire [15:0] shifted_data;
    wire [15:0] added_data;

    assign shifted_data = {data[14:0], 1'b0};
    assign added_data = data + shift_reg;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 16'b0;
        end else begin
            shift_reg <= shifted_data;
        end
    end

    assign result = added_data;
    assign greater_than_32767 = (added_data > 16'h7FFF);

endmodule