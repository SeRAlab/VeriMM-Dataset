module temp_sensor_controller (
    input wire clk,
    input wire reset,
    input wire [4:0] temp_input,
    output reg exceeds_threshold
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            exceeds_threshold <= 0;
        end else begin
            if (temp_input > 5'd25) 
                exceeds_threshold <= 1;
            else 
                exceeds_threshold <= 0;
        end
    end
endmodule