module gpio_controller(
    input wire clk,
    input wire reset,
    input wire mode,         // 0 for input mode, 1 for output mode
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;  // Reset output data
        end else begin
            if (mode) begin
                data_out <= data_in;   // Output mode: reflect input data
            end 
            // In input mode, no change to data_out
        end
    end
endmodule