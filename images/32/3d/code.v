module AStar (
    input [7:0] current_state,
    input [7:0] cost,
    input [7:0] heuristic,
    output reg [7:0] next_state
);
    always @(*) begin
        next_state = current_state + cost + heuristic;
    end
endmodule