module top_module(
    input signed [15:0] num_in1,
    input signed [15:0] num_in2,
    input max_or_min,
    input clk,           // Adding clk input
    input reset,         // Adding reset input
    output reg [15:0] num_out
);reg [15:0] max_value;
reg [15:0] min_value;

always @(*) begin
    if(num_in1 > num_in2) begin
        max_value = num_in1;
        min_value = num_in2;
    end else begin
        max_value = num_in2;
        min_value = num_in1;
    end
end

reg [1:0] stage = 0;

always @(posedge clk or posedge reset) begin // Modified to handle reset in sensitivity list
    if(reset) begin
        stage <= 0;
        num_out <= 0;
    end else begin
        case(stage)
            0: begin
                num_out <= max_or_min ? max_value : min_value;
                stage <= 1;
            end
            1: begin
                num_out <= num_out; // This line can be optimized, but retained for clarity
                stage <= 0;
            end
        endcase
    end
end

endmodule