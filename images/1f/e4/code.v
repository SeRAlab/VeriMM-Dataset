module temp_sensor_controller (
    input clk,
    input rst,
    input [9:0] temp_reading,
    output reg status
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            status <= 0;
        end else begin
            if (temp_reading > 750) begin
                status <= 1;
            end else begin
                status <= 0;
            end
        end
    end
endmodule