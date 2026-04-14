module binary_search (  
    input clk,  
    input [7:0] array,  
    input [2:0] target,  
    output reg found  
);  
    reg [2:0] low;  
    reg [2:0] high;  
    reg [2:0] mid;  
    reg [1:0] state;  

    parameter IDLE = 2'b00, INIT = 2'b01, SEARCH = 2'b10, DONE = 2'b11;  

    always @(posedge clk) begin  
        case (state)  
            IDLE: begin  
                if (array != 8'b0) begin  
                    low <= 0;  
                    high <= 8;  
                    found <= 0;  
                    state <= INIT;  
                end  
            end  
            INIT: begin  
                if (high >= low) begin  
                    mid <= (low + high) >> 1;  
                    if (array[mid] == target) begin  
                        found <= 1;  
                        state <= DONE;  
                    end else if (array[mid] > target) begin  
                        high <= mid - 1;  
                    end else begin  
                        low <= mid + 1;  
                    end  
                    state <= SEARCH;  
                end else begin  
                    found <= 0;  
                    state <= DONE;  
                end  
            end  
            SEARCH: begin  
                if (high >= low) begin  
                    mid <= (low + high) >> 1;  
                    if (array[mid] == target) begin  
                        found <= 1;  
                        state <= DONE;  
                    end else if (array[mid] > target) begin  
                        high <= mid - 1;  
                    end else begin  
                        low <= mid + 1;  
                    end  
                end else begin  
                    found <= 0;  
                    state <= DONE;  
                end  
            end  
            DONE: begin  
                state <= IDLE;  
            end  
        endcase  
    end  
endmodule