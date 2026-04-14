module butterworth_filter (
    input [4:0] current_input,
    input clk,
    output reg [4:0] filtered_output
);
    reg [4:0] previous_input;

    always @(posedge clk) begin
        filtered_output <= (current_input + previous_input) >> 1; // simple averaging
        previous_input <= current_input;
    end
endmodule