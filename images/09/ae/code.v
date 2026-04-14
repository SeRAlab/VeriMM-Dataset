module dvfs_controller(
    input [7:0] workload,
    output reg [1:0] frequency, // 00: 1GHz, 01: 2GHz, 10: 3GHz
    output reg [1:0] voltage // 00: 1V, 01: 1.5V, 10: 2V
);

always @(*) begin
    if (workload <= 8'd33) begin
        frequency = 2'b00; // 1GHz
        voltage = 2'b00;   // 1V
    end else if (workload <= 8'd66) begin
        frequency = 2'b01; // 2GHz
        voltage = 2'b01;   // 1.5V
    end else begin
        frequency = 2'b10; // 3GHz
        voltage = 2'b10;   // 2V
    end
end

endmodule