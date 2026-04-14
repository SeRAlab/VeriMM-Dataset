module dvfs_controller (
    input wire [7:0] workload,       // 8-bit workload signal
    input wire [2:0] voltage_level,   // 3-bit voltage level signal
    output reg [1:0] action           // 2-bit action: 00=maintain, 01=increase, 10=decrease
);
    always @(*) begin
        if (workload > 8'd70) begin
            action = 2'b01;  // Increase voltage
        end else if (workload < 8'd30) begin
            action = 2'b10;  // Decrease voltage
        end else begin
            action = 2'b00;  // Maintain voltage
        end
    end
endmodule