module turbo_encoder (
    input [3:0] data_in,
    input clk,
    input reset,
    output reg [5:0] encoded_out
);
    reg [3:0] data;
    reg [2:0] state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            encoded_out <= 6'b0;
            state <= 3'b000;
        end else begin
            data <= data_in; // Store incoming data
            // Simple encoding logic for Turbo Encoder
            case (state)
                3'b000: encoded_out <= {data[3], data[2], data[1]} ^ 3'b101; // Encoder 1
                3'b001: encoded_out <= {data[1], data[0], data[3]} ^ 3'b011; // Encoder 2
                default: encoded_out <= 6'b0;
            endcase
            state <= state + 1; // Next state
        end
    end
endmodule