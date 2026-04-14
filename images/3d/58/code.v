module dvfs_controller (
    input [7:0] workload,
    output reg [2:0] voltage, // 0: 1V, 1: 3V, 2: 5V
    output reg [3:0] frequency // 0: 1MHz, 1: 5MHz, 2: 10MHz
);
    
    always @(*) begin
        if (workload < 85) begin
            voltage = 3'b000; // 1V
            frequency = 4'b0000; // 1MHz
        end else if (workload < 170) begin
            voltage = 3'b001; // 3V
            frequency = 4'b0001; // 5MHz
        end else begin
            voltage = 3'b010; // 5V
            frequency = 4'b0010; // 10MHz
        end
    end
endmodule