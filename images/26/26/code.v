module eth_mac_controller (
    input wire clk,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg data_valid
);
    reg [7:0] buffer [0:7]; // 8 deep buffer
    reg [2:0] count; // 3-bit counter
    reg storing; // Flag to indicate storing process

    always @(posedge clk) begin
        if (storing) begin
            if (count < 7) begin
                count <= count + 1;
                buffer[count] <= data_in; // Store incoming data
            end else begin
                data_out <= buffer[count]; // Output last stored data
                data_valid <= 1; // Set valid signal
                count <= 0; // Reset counter for next frame
                storing <= 0; // Stop storing
            end
        end else begin
            // Start storing on the next rising edge when data is valid
            storing <= 1;
            count <= 0;
            buffer[0] <= data_in; // Start filling buffer
            data_valid <= 0; // Clear valid signal
        end
    end
endmodule