module RRTNode (
    input clk,
    input reset,
    input [4:0] position_x,
    input [4:0] position_y,
    input [3:0] parent_index,
    input set_node,
    output reg [4:0] out_position_x,
    output reg [4:0] out_position_y,
    output reg [3:0] out_parent_index
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_position_x <= 5'b00000;
        out_position_y <= 5'b00000;
        out_parent_index <= 4'b0000;
    end else if (set_node) begin
        out_position_x <= position_x;
        out_position_y <= position_y;
        out_parent_index <= parent_index;
    end
end

endmodule