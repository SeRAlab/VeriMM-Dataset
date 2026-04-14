module spi_master (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg mosi,
    output reg sck,
    output reg ss,
    input wire miso,
    output reg tx_complete
);
    reg [3:0] bit_cnt;
    reg [7:0] data_shifter;
    reg sending;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 1'b0;
            sck <= 1'b0;
            ss <= 1'b1;
            tx_complete <= 1'b0;
            bit_cnt <= 4'b0000;
            sending <= 1'b0;
        end else begin
            if (start && !sending) begin
                ss <= 1'b0; // select the slave
                data_shifter <= data_in;
                bit_cnt <= 4'b0000;
                sending <= 1'b1;
                tx_complete <= 1'b0;
            end
            
            if (sending) begin
                // Generate the clock signal
                sck <= ~sck;
                
                if (sck) begin // on rising edge
                    mosi <= data_shifter[7]; // send the MSB first
                    data_shifter <= {data_shifter[6:0], 1'b0}; // shift left
                    bit_cnt <= bit_cnt + 1'b1;
                end
                
                if (bit_cnt == 4'b0111 && sck) begin // after 8 bits
                    sending <= 1'b0;
                    ss <= 1'b1; // deselect the slave
                    tx_complete <= 1'b1; // indicate transmission complete
                end
            end
        end
    end
endmodule