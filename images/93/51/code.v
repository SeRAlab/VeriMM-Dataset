module top_module(
    input clk,
    input rx,
    input [7:0] data_in,
    output reg tx,      // Change to output reg
    output reg [7:0] data_out, // Change to output reg
    output reg rx_valid // Change to output reg
);reg [7:0] rdata;
    reg rx_valid_reg;
    wire [7:0] rx_char;
    reg [3:0] state;

    parameter IDLE = 4'b0000;         // Changed parameter size to match state variable
    parameter START_BIT = 4'b0001;   
    parameter DATA_BITS = 4'b0010;    
    parameter PARITY_BIT = 4'b0011;  

    initial begin
        tx <= 1'b1;
        state <= IDLE;
    end

    always @(posedge clk) begin
        case(state)
            IDLE: begin
                tx <= 1'b1;
                if(!rx) begin
                    state <= START_BIT;
                end
            end
            START_BIT: begin
                tx <= 1'b0;
                state <= DATA_BITS;
            end
            DATA_BITS: begin
                rdata[0] <= rx; // Collect each bit on rising edge
                if(rdata[0] != data_in[0]) begin
                    state <= IDLE;
                end else begin
                    // Shift bits into rdata
                    rdata[1] <= rx;
                    rdata[2] <= rx;
                    rdata[3] <= rx;
                    rdata[4] <= rx;
                    rdata[5] <= rx;
                    rdata[6] <= rx;
                    rdata[7] <= rx;
                    state <= PARITY_BIT;
                end
            end
            PARITY_BIT: begin
                tx <= 1'b1;
                // What should be rdata[8] is an incorrect indexing, assuming 8 bits only
                // so no need to refer to rdata[8], rather checking parity based on rdata[0] to rdata[7]
                if(rx != (rdata[0] ^ rdata[1] ^ rdata[2] ^ rdata[3] ^ rdata[4] ^ rdata[5] ^ rdata[6] ^ rdata[7])) begin
                    state <= IDLE;
                end else begin
                    state <= IDLE;
                    rx_valid_reg <= 1;
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if(rx_valid_reg) begin
            rx_valid <= 1;
            data_out <= rdata; // Correct to set data_out from rdata
            rx_valid_reg <= 0;
        end else begin
            rx_valid <= 0;
        end
    end

    // Receive
    always @(posedge clk) begin
        // No need for a wire to collect rx_char, substituting directly with rdata
        // rx_char <= (rx_valid_reg)?rdata:8'd0; // This line removed
    end

endmodule