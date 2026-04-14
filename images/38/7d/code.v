module fifo_queue #(parameter DEPTH = 8, parameter WIDTH = 8)  
(  
    input clk,  
    input rst,  
    input wr_en,  
    input rd_en,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  
    reg [WIDTH-1:0] memory [0:DEPTH-1];  
    reg [3:0] wr_ptr, rd_ptr, count;  
  
    always @(posedge clk or posedge rst)  
    begin  
        if (rst)  
        begin  
            wr_ptr <= 0;  
            rd_ptr <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end  
        else  
        begin  
            if (wr_en && !full)  
            begin  
                memory[wr_ptr] <= data_in;  
                wr_ptr <= (wr_ptr + 1) % DEPTH;  
                count <= count + 1;  
            end  
            if (rd_en && !empty)  
            begin  
                data_out <= memory[rd_ptr];  
                rd_ptr <= (rd_ptr + 1) % DEPTH;  
                count <= count - 1;  
            end  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule