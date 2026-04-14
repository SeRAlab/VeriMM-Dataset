module sample_rate_converter (
    input clk,
    input reset,
    input [7:0] din,
    input wr_en,
    output reg [7:0] dout,
    output reg rd_en,
    output reg full,
    output reg empty
);
    reg [7:0] buffer [0:7]; // FIFO buffer of size 8
    reg [2:0] wr_ptr, rd_ptr;
    reg [3:0] count; // Number of items in the buffer

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            dout <= 0;
            full <= 0;
            empty <= 1;
            rd_en <= 0;
        end else begin
            // Write logic
            if (wr_en && !full) begin
                buffer[wr_ptr] <= din;
                wr_ptr <= (wr_ptr + 1) % 8;
                count <= count + 1;
            end
            
            // Update full and empty flags
            full <= (count == 8);
            empty <= (count == 0);
            
            // Read logic
            if (!empty) begin
                dout <= buffer[rd_ptr];
                rd_en <= 1;
                rd_ptr <= (rd_ptr + 1) % 8;
                count <= count - 1;
            end else begin
                rd_en <= 0;
            end
        end
    end
endmodule