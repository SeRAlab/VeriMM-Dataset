module gpio_controller (
    input wire [3:0] data_in,
    input wire read,
    input wire write,
    input wire reset,
    input wire clk,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000; // Initialize output to zero
        end else begin
            if (write) begin
                data_out <= data_in; // Store the data when write is high
            end
        end
    end

    always @(posedge clk) begin
        if (read) begin
            // Output the current state of data_out when read is high
            // This is implicitly done as data_out gets updated on write.
        end
    end
endmodule