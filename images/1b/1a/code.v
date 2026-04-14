module SwitchingRegulator (
    input wire [4:0] Vin,
    input wire Ctrl,
    input wire Enable,
    output reg [4:0] Vout
);

always @(*) begin
    if (Enable) begin
        if (Ctrl) 
            Vout = 5'b11111; // 5V
        else 
            Vout = 5'b00000; // 0V
    end else begin
        Vout = 5'b00000; // 0V when not enabled
    end
end

endmodule