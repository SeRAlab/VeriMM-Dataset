module Shift_Register_Left
(   input wire Clock,
    input wire [31:0] Data,
    input wire Enable,
    output reg [31:0] Shifted_Data
);
    reg newClock;

    initial begin 
        newClock = 0;
    end

    always begin
        #125 newClock = ~newClock;
    end

    always @(posedge newClock) begin
        if (Enable) begin
            Shifted_Data = {Data[30:0], 1'b0};
        end else begin
            Shifted_Data = Data;
        end
    end

endmodule