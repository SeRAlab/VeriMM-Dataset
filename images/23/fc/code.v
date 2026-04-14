module fifo_queue #(parameter WIDTH = 8, DEPTH = 16) (  
    input wire clk,  
    input wire rst,  
    input wire wr_en,  
    input wire rd_en,  
    input wire [WIDTH-1:0] din,  
    output reg [WIDTH-1:0] dout,  
    output reg full,  
    output reg empty  
);  

    reg [WIDTH-1:0] memory [0:DEPTH-1];  
    reg [3:0] wr_ptr;  
    reg [3:0] rd_ptr;  
    reg [4:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            wr_ptr <= 0;  
            rd_ptr <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            // Write operation  
            if (wr_en && !full) begin  
                memory[wr_ptr] <= din;  
                wr_ptr <= (wr_ptr + 1) % DEPTH;  
                count <= count + 1;  
            end  

            // Read operation  
            if (rd_en && !empty) begin  
                dout <= memory[rd_ptr];  
                rd_ptr <= (rd_ptr + 1) % DEPTH;  
                count <= count - 1;  
            end  

            // Update full and empty flags  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule