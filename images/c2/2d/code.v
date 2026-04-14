module up_down_counter (
    input clk,
    input reset,
    input load,
    input direction,
    input [3:0] data_in,
    output reg [3:0] count
);

    always @(posedge clk or negedge reset) begin
        if (reset == 0) begin
            count <= 4'b0000;
        end else if (load == 0) begin
            count <= data_in;
        end else if (direction == 1) begin
            count <= count + 1;
        end else begin
            count <= count - 1;
        end
    end

endmodule