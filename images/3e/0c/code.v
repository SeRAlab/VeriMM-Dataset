module pcie_interface (
    input clk,
    input reset,
    input [31:0] data_in,
    input data_valid,
    output reg [31:0] data_out,
    output reg data_ready
);
    parameter DELAY = 2; // number of clock cycles to delay
    reg [1:0] delay_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0;
            data_ready <= 1'b0;
            delay_counter <= 2'b0;
        end else begin
            if (data_valid) begin
                delay_counter <= 2'b0; // reset delay counter on new valid data
                data_ready <= 1'b0; // not ready until the delay is complete
            end else if (delay_counter < DELAY) begin
                delay_counter <= delay_counter + 1;
            end else if (delay_counter == DELAY) begin
                data_out <= data_in; // output the data after the delay
                data_ready <= 1'b1; // indicate that data is ready
            end
        end
    end
endmodule