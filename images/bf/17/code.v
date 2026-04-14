module top_module(
    input clk,
    input rst,
    input [7:0] tx_data,
    output reg tx
);parameter BAUD_RATE = 9600;
parameter CLK_FREQ = 50000000;

reg [3:0] state;
reg [3:0] count;
reg start_bit;
reg [7:0] data_reg;

// Assign tx based on the state transitions
always @* begin
    case (state)
        4'b0000: tx = 1'b1; // IDLE state
        4'b0001: tx = start_bit; // START bit
        4'b0010: tx = data_reg[0]; // DATA bits
        4'b0100: tx = 1'b1; // STOP bit
        default: tx = 1'b1; // Default to IDLE
    endcase
end

always @(posedge clk) begin
    if (rst) begin
        state <= 4'b0000;
        count <= 4'b0000;
        start_bit <= 1'b0;
        data_reg <= 8'b0;
        tx <= 1'b1;
    end else begin
        case (state)
            4'b0000: begin // IDLE
                if (tx_data[0] == 1'b0) begin
                    start_bit <= 1'b0;
                    data_reg <= tx_data;
                    count <= 4'b0001;
                    state <= 4'b0001;
                end
            end
            4'b0001: begin // START
                start_bit <= 1'b1;
                count <= count + 1;
                if (count == CLK_FREQ / BAUD_RATE) begin
                    count <= 4'b0000;
                    state <= 4'b0010;
                end
            end
            4'b0010: begin // DATA
                count <= count + 1;
                if (count == CLK_FREQ / BAUD_RATE) begin
                    count <= 4'b0000;
                    data_reg <= {1'b0, data_reg[7:1]}; // Shift data left and append '0'
                    if (data_reg == 8'b0) begin
                        state <= 4'b0100; // Go to STOP if no more data
                    end else begin
                        state <= 4'b0010; // Continue sending data
                    end
                end
            end
            4'b0100: begin // STOP
                start_bit <= 1'b1;
                count <= count + 1;
                if (count == CLK_FREQ / BAUD_RATE) begin
                    count <= 4'b0000;
                    state <= 4'b0000;
                end
            end
        endcase
    end
end

endmodule