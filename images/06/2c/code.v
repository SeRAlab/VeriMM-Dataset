module hash_table (  
    input clk,  
    input reset,  
    input [31:0] insert_value,  
    input insert_valid,  
    input [31:0] retrieve_value,  
    input retrieve_valid,  
    output reg [31:0] retrieve_result,  
    output reg insert_success  
);  

    reg [31:0] hash_table [0:7];  
    reg [2:0] index;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < 8; i = i + 1)  
                hash_table[i] <= 32'b0;  
            insert_success <= 1'b0;  
            retrieve_result <= 32'b0;  
        end else begin  
            if (insert_valid) begin  
                index <= insert_value % 8;  
                if (hash_table[index] == 32'b0) begin  
                    hash_table[index] <= insert_value;  
                    insert_success <= 1'b1;  
                end else begin  
                    insert_success <= 1'b0;  
                end  
            end  
            if (retrieve_valid) begin  
                index <= retrieve_value % 8;  
                if (hash_table[index] == retrieve_value) begin  
                    retrieve_result <= hash_table[index];  
                end else begin  
                    retrieve_result <= 32'b11111111111111111111111111111111; // -1 in 32-bit representation  
                end  
            end  
        end  
    end  
endmodule