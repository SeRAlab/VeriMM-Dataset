module top_module(
    input wire clk,
    input wire reset,
    output reg [3:0] count,
    output wire [3:0] leds
);reg [3:0] next_count;

    always @ (posedge clk, posedge reset)
    begin
        if (reset)
            count <= 4'b0000;
        else
            count <= next_count;
    end

    always @ (count)
    begin
        next_count = count + 1;
    end

    assign leds = count;

endmodule