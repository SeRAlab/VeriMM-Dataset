module sample_rate_converter (
    input wire clk_in,     // Input clock (2x)
    input wire rst,        // Reset signal
    input wire [7:0] data_in,  // Input data
    output reg [7:0] data_out,  // Output data
    output reg valid_out    // Output valid signal
);
    reg [1:0] counter;     // Counter to keep track of samples

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            data_out <= 8'b0;
            valid_out <= 1'b0;
            counter <= 2'b0;
        end else begin
            if (counter == 2'b00) begin
                data_out <= data_in; // Pass the data
                valid_out <= 1'b1; // Indicate valid data
                counter <= counter + 1; // Increment counter
            end else begin
                valid_out <= 1'b0; // Indicate no valid data
                counter <= counter + 1; // Increment counter
            end
            
            if (counter == 2'b10) begin
                counter <= 2'b0; // Reset counter after two cycles
            end
        end
    end
endmodule