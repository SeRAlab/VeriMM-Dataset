module fifo_queue #(parameter DEPTH = 4, DATA_WIDTH = 8) (  
    input clk,  
    input rst,  
    input [DATA_WIDTH-1:0] data_in,  
    input write_en,  
    input read_en,  
    output reg [DATA_WIDTH-1:0] data_out,  
    output reg empty,  
    output reg full  
);  

    reg [DATA_WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [1:0] wr_ptr;  
    reg [1:0] rd_ptr;  
    integer count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            wr_ptr <= 0;  
            rd_ptr <= 0;  
            count <= 0;  
            empty <= 1;  
            full <= 0;  
            data_out <= 0;  
        end else begin  
            if (write_en && !full) begin  
                fifo[wr_ptr] <= data_in;  
                wr_ptr <= (wr_ptr + 1) % DEPTH;  
                count <= count + 1;  
            end  

            if (read_en && !empty) begin  
                data_out <= fifo[rd_ptr];  
                rd_ptr <= (rd_ptr + 1) % DEPTH;  
                count <= count - 1;  
            end  

            empty <= (count == 0);  
            full <= (count == DEPTH);  
        end  
    end  
endmodule