module astar_cost_calculator (
    input [7:0] current_cost,  // g(n)
    input [7:0] estimated_cost, // h(n)
    input control,              // control signal
    output reg [7:0] total_cost // f(n)
);

always @(*) begin
    if (control) begin
        total_cost = current_cost + estimated_cost; // f(n) = g(n) + h(n)
    end else begin
        total_cost = 8'b00000000; // Default output
    end
end

endmodule