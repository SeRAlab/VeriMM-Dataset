module LZW_Compressor (  
    input clk,  
    input reset,  
    input [3:0] data_in,  
    output reg [5:0] code_out,  
    output reg valid  
);  

    reg [15:0] dictionary [0:15]; // Simple dictionary for sequences  
    reg [3:0] current_sequence;  
    reg [3:0] next_sequence;  
    integer i;  

    initial begin  
        // Initialize dictionary with some known sequences  
        dictionary[0] = 4'b0000;  
        dictionary[1] = 4'b0001;  
        dictionary[2] = 4'b0010;  
        dictionary[3] = 4'b0011;  
        // ... more initializations as required  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            valid <= 0;  
            code_out <= 6'b0;  
            current_sequence <= 4'b0;  
        end else begin  
            current_sequence <= data_in;  
            valid <= 1;  
            // Simple logic to find the code for the current sequence  
            for (i = 0; i < 16; i = i + 1) begin  
                if (dictionary[i] == current_sequence) begin  
                    code_out <= i[5:0]; // Output the index of the sequence  
                end  
            end  
        end  
    end  
endmodule