module binary_counter#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire load_en,
    input wire [WIDTH-1:0] load_val,
    output reg [WIDTH-1:0] count
);

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        count <= 0;
    end else if (load_en) begin
        count <= load_val;
    end else begin
        count <= count + 1;
    end
end

endmodule