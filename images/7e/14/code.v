module down_counter#(
    parameter WIDTH = 12
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [WIDTH-1:0] load_value,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        count <= 0;
    end else if (load) begin
        count <= load_value;
    end else if (en) begin
        count <= count - 1;
    end
end

endmodule