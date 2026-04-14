module RLE (  
    input wire clk,  
    input wire reset,  
    input wire [63:0] data_in,  
    output reg [63:0] run_length_out,  
    output reg [63:0] value_out,  
    output reg valid  
);  
    reg [5:0] current_count;  
    reg [63:0] current_data;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            current_count <= 0;  
            current_data <= 0;  
            valid <= 0;  
            run_length_out <= 0;  
            value_out <= 0;  
        end else begin  
            current_data <= data_in;  
            current_count <= 1;  
            valid <= 1;  
            run_length_out <= 0;  
            value_out <= 0;  

            for (i = 0; i < 64; i = i + 1) begin  
                if (i == 63 || current_data[i] != current_data[i + 1]) begin  
                    run_length_out <= {run_length_out[62:0], current_count};  
                    value_out <= {value_out[62:0], current_data[i]};  
                    current_count <= 1;  
                end else begin  
                    current_count <= current_count + 1;  
                end  
            end  
        end  
    end  
endmodule