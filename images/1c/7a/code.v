module stack_lifo #(parameter DEPTH = 8, parameter WIDTH = 8) (  
    input clk,  
    input rst,  
    input push_en,  
    input pop_en,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg [WIDTH-1:0] top_data,  
    output reg empty,  
    output reg full  
);  
    reg [WIDTH-1:0] stack [0:DEPTH-1];  
    reg [3:0] ptr;  // Pointer to track the top of the stack  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ptr <= 0;  
            empty <= 1;  
            full <= 0;  
            top_data <= 0;  
            data_out <= 0;  
        end else begin  
            if (push_en && !full) begin  
                stack[ptr] <= data_in;  
                ptr <= ptr + 1;  
                empty <= 0;  
                if (ptr == DEPTH - 1) full <= 1;  
                top_data <= data_in;  
            end  
            if (pop_en && !empty) begin  
                ptr <= ptr - 1;  
                data_out <= stack[ptr];  
                if (ptr == 1) empty <= 1;  
                full <= 0;  
                top_data <= (ptr > 1) ? stack[ptr - 1] : 0;  
            end  
        end  
    end  
endmodule