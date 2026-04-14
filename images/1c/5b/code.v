module current_sensor (
    input wire clk,
    input wire reset,
    input wire [3:0] current_input,
    output reg [2:0] current_status
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_status <= 3'b000; // Reset output
        end else begin
            case (current_input)
                4'b0000: current_status <= 3'b000; // 0 mA
                4'b0001: current_status <= 3'b000; // 1 mA
                4'b0010: current_status <= 3'b000; // 2 mA
                4'b0011: current_status <= 3'b000; // 3 mA
                4'b0100: current_status <= 3'b000; // 4 mA
                4'b0101: current_status <= 3'b001; // 5 mA
                4'b0110: current_status <= 3'b001; // 6 mA
                4'b0111: current_status <= 3'b001; // 7 mA
                4'b1000: current_status <= 3'b001; // 8 mA
                4'b1001: current_status <= 3'b001; // 9 mA
                default: current_status <= 3'b010; // 10 mA and above
            endcase
        end
    end
endmodule