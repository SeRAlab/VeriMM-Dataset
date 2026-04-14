module current_sensor_logger (
    input wire clk,
    input wire reset,
    input wire [7:0] current_data,
    output reg [3:0] counter,
    output reg [7:0] logged_data
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            logged_data <= 8'b00000000;
        end else begin
            logged_data <= current_data;
            counter <= counter + 1;
        end
    end

endmodule