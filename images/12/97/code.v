module spi_master (
    input wire clk,               // system clock
    input wire reset,             // reset signal
    input wire [7:0] data_in,     // data input to send
    input wire start,             // start signal
    output reg mosi,              // master out, slave in
    output reg sck,               // serial clock
    input wire miso,              // master in, slave out
    output reg cs,                // chip select
    output reg done               // done signal
);
    
    reg [3:0] bit_count;          // count the bits
    reg [7:0] data_out;           // data register
    reg sending;                  // flag to indicate sending process

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mosi <= 0;
            sck <= 0;
            cs <= 1;               // chip select inactive
            done <= 0;
            bit_count <= 0;
            sending <= 0;
        end else begin
            if (start && !sending) begin
                cs <= 0;           // activate chip select
                data_out <= data_in;
                bit_count <= 8;    // start sending 8 bits
                sending <= 1;      
                done <= 0;         
            end
            
            if (sending) begin
                if (bit_count > 0) begin
                    sck <= ~sck;     // toggle clock
                    if (sck) begin
                        mosi <= data_out[bit_count-1]; // send bit
                    end else begin
                        data_out[bit_count-1] <= miso; // receive bit
                        bit_count <= bit_count - 1; // decrease count
                    end
                end else begin
                    sending <= 0;      // done sending
                    cs <= 1;           // deactivate chip select
                    done <= 1;         // signal done
                end
            end
        end
    end
endmodule