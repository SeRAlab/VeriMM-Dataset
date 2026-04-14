module fifo_queue #(parameter WIDTH = 4, DEPTH = 4) (  
    input clk,  
    input we,  
    input re,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg [2:0] count  
);  
    reg [WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [1:0] head, tail;  
    initial begin  
        head = 0;  
        tail = 0;  
        count = 0;  
        data_out = 0;  
    end  

    always @(posedge clk) begin  
        if (we && count < DEPTH) begin  
            fifo[tail] <= data_in;  
            tail <= (tail + 1) % DEPTH;  
            count <= count + 1;  
        end  
        if (re && count > 0) begin  
            data_out <= fifo[head];  
            head <= (head + 1) % DEPTH;  
            count <= count - 1;  
        end  
    end  
endmodule