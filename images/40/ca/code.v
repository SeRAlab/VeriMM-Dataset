module turbo_encoder(  
    input clk,  
    input reset,  
    input [1:0] data_in,  
    output reg [3:0] encoded_out  
);  
    reg [1:0] interleaved;  
    reg [3:0] conv_out1;  
    reg [3:0] conv_out2;  
    
    // Simple convolutional encoder 1  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            conv_out1 <= 4'b0;  
        end else begin  
            conv_out1 <= {data_in[1] ^ data_in[0], data_in[1], data_in[0], 1'b0};  
        end  
    end  
    
    // Simple convolutional encoder 2 (interleaved)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            interleaved <= 2'b0;  
        end else begin  
            interleaved <= {data_in[0], data_in[1]};  
        end  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            conv_out2 <= 4'b0;  
        end else begin  
            conv_out2 <= {interleaved[1] ^ interleaved[0], interleaved[1], interleaved[0], 1'b0};  
        end  
    end  
    
    // Combining outputs of both encoders  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            encoded_out <= 4'b0;  
        end else begin  
            encoded_out <= {conv_out1[3:2], conv_out2[1:0]};  
        end  
    end  
endmodule