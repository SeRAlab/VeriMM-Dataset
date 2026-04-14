module counter#(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire preset,
    input wire [WIDTH-1:0] preset_value,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        count <= 0;
    end else if (preset) begin
        count <= preset_value;
    end else if (en) begin
        count <= count + 1;
    end
end

endmodule