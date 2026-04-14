module dvfs_controller (
    input [7:0] temperature,
    output reg [2:0] voltage, // 000: 1.0V, 001: 0.9V, 010: 0.8V
    output reg [2:0] frequency // 000: 1.0GHz, 001: 900MHz, 010: 800MHz
);
    
    always @(*) begin
        if (temperature < 30) begin
            voltage = 3'b000;    // 1.0V
            frequency = 3'b000;  // 1.0GHz
        end else if (temperature >= 30 && temperature <= 70) begin
            voltage = 3'b001;    // 0.9V
            frequency = 3'b001;  // 900MHz
        end else begin
            voltage = 3'b010;    // 0.8V
            frequency = 3'b010;  // 800MHz
        end
    end
endmodule