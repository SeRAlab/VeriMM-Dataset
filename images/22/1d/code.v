module bluetooth_status_generator(
    input wire power_on,
    input wire connected,
    output reg [1:0] status
);
    always @(*) begin
        if (!power_on) begin
            status = 2'b00; // OFF
        end else if (!connected) begin
            status = 2'b01; // READY
        end else begin
            status = 2'b10; // CONNECTED
        end
    end
endmodule