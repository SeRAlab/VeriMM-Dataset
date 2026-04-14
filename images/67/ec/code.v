module top_module(
    input clk,                   // Added clock input
    input [1:0] state_reg,
    input [3:0] text_on,
    input graph_on,
    output reg [2:0] rgb
);reg [2:0] rgb_next;
parameter [2:0] text_rgb = 3'b111; // white text
parameter [2:0] graph_rgb = 3'b001; // blue graph

always @(*) begin
    // display score, rule, or game over
    case ({state_reg, text_on})
        {2'b00, 4'b0001}: // score
            rgb_next = text_rgb;
        {2'b01, 4'b0010}: // rule
            rgb_next = text_rgb;
        {2'b10, 4'b0001}: // game over
            rgb_next = text_rgb;
        default:
            if (graph_on) // display graph
                rgb_next = graph_rgb;
            else if (text_on[2]) // display logo
                rgb_next = text_rgb;
            else // yellow background
                rgb_next = 3'b110;
    endcase
end

always @(posedge clk) begin
    rgb <= rgb_next;
end

endmodule