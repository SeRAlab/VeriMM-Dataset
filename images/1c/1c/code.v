module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [4:0] data_in,
    input wire ctrl,
    output reg [4:0] data_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 5'b00000; // Reset output to 0
        end else if (ctrl) begin
            data_out <= data_in; // Latch data_in to data_out
        end
    end
endmodule