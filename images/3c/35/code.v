module turbo_encoder(input [3:0] data_in, input clk, input reset, output reg [7:0] data_out);  
    reg [3:0] interleaved_data;  
    reg [3:0] encoded1, encoded2;  

    // Simple convolutional encoding (example only)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            encoded1 <= 4'b0;  
            encoded2 <= 4'b0;  
            interleaved_data <= 4'b0;  
            data_out <= 8'b0;  
        end else begin  
            // Interleave data  
            interleaved_data <= {data_in[0], data_in[2], data_in[1], data_in[3]};  
            
            // Example encoding (not real Turbo encoding)  
            encoded1 <= {interleaved_data[3], interleaved_data[2], interleaved_data[1], interleaved_data[0]};  
            encoded2 <= {interleaved_data[1], interleaved_data[0], interleaved_data[3], interleaved_data[2]};  
            
            // Concatenate the two encoded outputs  
            data_out <= {encoded1, encoded2};  
        end  
    end  
endmodule