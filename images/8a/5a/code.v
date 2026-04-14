module top_module(
    input clk,
    input reset,
    input up_down,
    output reg [2:0] count,
    output max_reached
);reg [2:0] next_count;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            count <= 3'b0;
        end else begin
            if (up_down) begin
                next_count <= count + 1;
            end else begin
                next_count <= count - 1;
            end
            count <= next_count;
        end
    end

    assign max_reached = (count == 3'b111);

endmodule