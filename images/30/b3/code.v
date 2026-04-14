module rrt_node_selector(
    input wire clk,
    input wire reset,
    input wire [2:0] current_node,
    output reg [2:0] next_node
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        next_node <= 3'b000; // Reset next node to 0
    end else begin
        case (current_node % 4)
            3'b000: next_node <= 3'b001;
            3'b001: next_node <= 3'b010;
            3'b010: next_node <= 3'b011;
            3'b011: next_node <= 3'b100;
            default: next_node <= 3'b000; // Default case
        endcase
    end
end

endmodule