module top_module(
    input wire clk,    // clock input
    input wire rst,    // reset input
    input wire SerialIn,   // serial input
    output wire [3:0] BusOut   // parallel output
);reg [3:0] SIPO_Buffer = 0;   // 4-bit buffer

always @(posedge clk, negedge rst) begin
    if (!rst) begin
        SIPO_Buffer <= 0;   // clear buffer on reset
    end
    else begin
        SIPO_Buffer <= {SIPO_Buffer[2:0], SerialIn};   // shift data into buffer
    end
end

assign BusOut = SIPO_Buffer;   // output buffer on parallel bus

endmodule