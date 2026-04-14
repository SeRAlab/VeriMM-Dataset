module wifi_signal_strength (
    input [4:0] rssi1,
    input [4:0] rssi2,
    output reg [4:0] stronger_rssi
);
    always @(*) begin
        if (rssi1 >= rssi2) 
            stronger_rssi = rssi1;
        else 
            stronger_rssi = rssi2;
    end
endmodule