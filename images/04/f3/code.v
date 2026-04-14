module rle_encoder(  
    input wire clk,  
    input wire reset,  
    input wire data_in,  
    output reg [3:0] run_length,  
    output reg data_out,  
    output reg valid  
);  
    reg [3:0] count;  
    reg last_data;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            run_length <= 0;  
            data_out <= 0;  
            valid <= 0;  
            last_data <= 0;  
        end else begin  
            if (data_in == last_data) begin  
                count <= count + 1;  
            end else begin  
                if (count > 0) begin  
                    run_length <= count;  
                    data_out <= last_data;  
                    valid <= 1;  
                end  
                count <= 1;  
                last_data <= data_in;  
            end  
        end  
    end  
endmodule