module top_module(
    input counter_clk,
    input [6:0] in_x, in_y,
    input en,
    input reset, 
    output comp
);reg in_x_d;
    wire x_stable, y_eq_x;

    assign x_stable = (in_x_d==in_x);
    assign y_eq_x   = (in_x==in_y);
    assign comp = (en && (y_eq_x) && !(x_stable));

    always @(posedge counter_clk)begin
        in_x_d <= in_x;
    end

endmodule