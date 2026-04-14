module fifo_queue  
#(parameter DATA_WIDTH = 8, DEPTH = 4)  
(  
    input wire clk,  
    input wire rst,  
    input wire wr_en,  
    input wire rd_en,  
    input wire [DATA_WIDTH-1:0] din,  
    output reg [DATA_WIDTH-1:0] dout,  
    output reg full,  
    output reg empty  
);  

    reg [DATA_WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [1:0] wr_ptr, rd_ptr;  
    integer count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            wr_ptr <= 2'b00;  
            rd_ptr <= 2'b00;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            if (wr_en && !full) begin  
                fifo[wr_ptr] <= din;  
                wr_ptr <= (wr_ptr + 1) % DEPTH;  
                count <= count + 1;  
            end  

            if (rd_en && !empty) begin  
                dout <= fifo[rd_ptr];  
                rd_ptr <= (rd_ptr + 1) % DEPTH;  
                count <= count - 1;  
            end  

            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule