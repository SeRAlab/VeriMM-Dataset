module fifo_queue (  
    input clk,  
    input wr_en,  
    input rd_en,  
    input [3:0] data_in,  
    output reg [3:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [3:0] fifo [3:0];  
    reg [1:0] wr_ptr;  
    reg [1:0] rd_ptr;  
    integer count;  

    initial begin  
        wr_ptr = 0;  
        rd_ptr = 0;  
        count = 0;  
        full = 0;  
        empty = 1;  
    end  

    always @(posedge clk) begin  
        if (wr_en && !full) begin  
            fifo[wr_ptr] <= data_in;  
            wr_ptr <= (wr_ptr + 1) % 4;  
            count <= count + 1;  
        end  
        if (rd_en && !empty) begin  
            data_out <= fifo[rd_ptr];  
            rd_ptr <= (rd_ptr + 1) % 4;  
            count <= count - 1;  
        end  
        full <= (count == 4);  
        empty <= (count == 0);  
    end  
endmodule