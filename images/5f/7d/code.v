module top_module(
    input wire Clock,
    input wire [31:0] Data,
    input wire Enable,
    output reg [31:0] Shifted_Data
);reg newClock;

    initial begin
        newClock = 0;
    end

    always begin
        #125 newClock = 1;
        #125 newClock = 0;
    end

    always @(posedge newClock) begin
        if (Enable) begin
            Shifted_Data = Data >> 1;
        end
        else begin
            Shifted_Data = Data;
        end
    end

endmodule