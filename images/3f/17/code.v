module DVFS_Controller (
    input wire clk,
    input wire rst,
    input wire [1:0] control,
    output reg [1:0] frequency, // 00: 1GHz, 01: 2GHz, 10: 3GHz
    output reg [1:0] voltage     // 00: 0.9V, 01: 1.0V, 10: 1.2V
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        frequency <= 2'b00; // Default to 1GHz
        voltage <= 2'b00;   // Default to 0.9V
    end else begin
        case (control)
            2'b00: begin
                frequency <= 2'b00; // 1GHz
                voltage <= 2'b00;   // 0.9V
            end
            2'b01: begin
                frequency <= 2'b01; // 2GHz
                voltage <= 2'b01;   // 1.0V
            end
            2'b10: begin
                frequency <= 2'b10; // 3GHz
                voltage <= 2'b10;   // 1.2V
            end
            2'b11: begin
                // Reserved for future use
                frequency <= frequency; // maintain current state
                voltage <= voltage;     // maintain current state
            end
        endcase
    end
end

endmodule