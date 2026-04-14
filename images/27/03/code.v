module priority_encoder (
    input wire [3:0] I, // 4 input lines
    input wire enable,   // enable signal
    output reg [1:0] Y  // 2-bit output
);
    always @* begin
        if (!enable) begin
            Y = 2'b00; // Output 0 if enable is low
        end else begin
            casez (I) // casez allows us to use don't care conditions
                4'b1???: Y = 2'b00; // I0 is high
                4'b01??: Y = 2'b01; // I1 is high
                4'b001?: Y = 2'b10; // I2 is high
                4'b0001: Y = 2'b11; // I3 is high
                default: Y = 2'b00; // default case
            endcase
        end
    end
endmodule