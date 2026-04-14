module top_module(
    input clk,
    input [7:0] in,
    output [3:0] q
);reg [7:0] prev_in;
    reg edge_detect;
    reg pulse;
    reg [3:0] counter;

    always @(posedge clk) begin
        prev_in <= in;
        edge_detect <= (prev_in[0] == 1) && (in[0] == 0);
        pulse <= (edge_detect == 1) ? 1 : 0;
        if (pulse == 1) begin
            if (counter == 15) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    assign q = counter;

endmodule