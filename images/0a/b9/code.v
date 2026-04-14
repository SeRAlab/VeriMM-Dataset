module md5_hash(input clk, input rst, input en, input [127:0] data_in, output reg [127:0] hash_out);  
    reg [127:0] state;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 128'h0;  
            hash_out <= 128'h0;  
        end else if (en) begin  
            // Simple transformation for demonstration  
            state = state + data_in;  
            for (i = 0; i < 16; i = i + 1) begin  
                state = {state[119:0], state[127:120]} ^ (state + i);  
            end  
            hash_out <= state;  
        end  
    end  
endmodule