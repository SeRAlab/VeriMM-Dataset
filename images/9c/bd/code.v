module top_module(
    input clk,                // Added clock input
    input input_signal,
    input [1:0] delay_amount,
    output reg output_signal
);reg [3:0] delay_counter;

always @(posedge clk) begin
    if(delay_amount == 0) begin
        delay_counter <= 1;
    end else if(delay_amount == 1) begin
        delay_counter <= 2;
    end else if(delay_amount == 2) begin
        delay_counter <= 4;  // Changed to use delay_amount correctly
    end
    
    if(delay_counter > 0) begin
        delay_counter <= delay_counter - 1;
    end

    if(delay_counter == 0) begin
        output_signal <= input_signal; // Set the output when delay is finished
    end else begin
        output_signal <= 0; // Maintain output low during delay
    end
end

endmodule