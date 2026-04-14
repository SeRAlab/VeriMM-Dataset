module top_module(
    input clk,
    input up_down,
    input load,
    input [3:0] data,
    input [1:0] shift,
    output reg [3:0] result
);reg [3:0] counter_value;

always @(posedge clk) begin
    if (load) begin
        counter_value <= data;
    end else begin
        if (up_down) begin
            counter_value <= counter_value + 1;
        end else begin
            counter_value <= counter_value - 1;
        end
        
        case (shift)
            2'b00: result <= counter_value;
            2'b01: result <= counter_value >> 1;
            2'b10: result <= counter_value << 1;
            2'b11: result <= counter_value >> 2;
        endcase
    end
end

endmodule