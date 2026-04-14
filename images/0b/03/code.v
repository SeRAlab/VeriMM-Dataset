module convolutional_encoder(
    input wire clk,
    input wire rst,
    input wire data_in,
    output reg [1:0] data_out
);
    reg input_delay;
    reg input_delay_delay;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            input_delay <= 0;
            input_delay_delay <= 0;
            data_out <= 2'b00;
        end else begin
            data_out[0] <= data_in ^ input_delay; // Output 1
            data_out[1] <= data_in ^ input_delay ^ input_delay_delay; // Output 2
            
            // Update delays
            input_delay_delay <= input_delay;
            input_delay <= data_in;
        end
    end
endmodule