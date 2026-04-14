module deserializer (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [15:0] data_out
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 16'b0;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    data_out[7:0] <= data_in; // First 8 bits
                    state <= 2'b01;
                end
                2'b01: begin
                    data_out[15:8] <= data_in; // Second 8 bits
                    state <= 2'b00; // Go back to initial state
                end
            endcase
        end
    end
endmodule