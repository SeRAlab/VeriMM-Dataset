module sd_card_controller(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire write_enable,
    output reg write_done
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            write_done <= 0;
        end else if (write_enable) begin
            // Simulate writing data to the SD card
            // Here we would normally have code that interacts with the SD card interface
            write_done <= 1;
        end else begin
            write_done <= 0;
        end
    end
endmodule