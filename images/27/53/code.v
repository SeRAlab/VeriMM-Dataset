module butterworth_filter (  
    input [4:0] current_input,  
    input clk,  
    input rst,  
    output reg [4:0] filtered_output  
);  
    reg [4:0] previous_1;  
    reg [4:0] previous_2;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            previous_1 <= 5'b0;  
            previous_2 <= 5'b0;  
            filtered_output <= 5'b0;  
        end else begin  
            filtered_output <= (current_input + previous_1 + previous_2) / 3;  
            previous_2 <= previous_1;  
            previous_1 <= current_input;  
        end  
    end  
endmodule