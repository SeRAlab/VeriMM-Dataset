module deadbeat_controller(
    input clk,
    input rst,
    input [1:0] input_signal,
    output reg [1:0] output_signal
);

reg [1:0] next_state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        output_signal <= 2'b00;
    end else begin
        output_signal <= next_state;
    end
end

always @(*) begin
    next_state = input_signal;
end

endmodule