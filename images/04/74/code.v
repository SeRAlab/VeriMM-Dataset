module bluetooth_transmitter (
    input wire clk,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [1:0] state;

    always @(posedge clk) begin
        if (data_in > 4'b1111) begin
            data_out <= 4'b0000; // Invalid input
        end else begin
            case (state)
                2'b00: begin
                    data_out <= data_in; // Load data
                    state <= 2'b01;
                end
                2'b01: begin
                    state <= 2'b10; // Move to the next state
                end
                2'b10: begin
                    data_out <= data_out; // Transmit data
                    state <= 2'b00; // Reset state
                end
            endcase
        end
    end

    initial begin
        state = 2'b00;
    end
endmodule