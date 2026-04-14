module turbo_decoder (
    input wire clk,
    input wire rst,
    input wire [4:0] input_data,
    output reg [4:0] output_data
);
    reg [4:0] interleaved_data;
    
    // Simple convolutional decoder
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            output_data <= 5'b0;
            interleaved_data <= 5'b0;
        end else begin
            // Interleave the input data
            interleaved_data <= {input_data[1], input_data[0], input_data[3], input_data[2], input_data[4]};
            // Decode (for simplicity, just inverting the interleaved data)
            output_data <= ~interleaved_data;
        end
    end
endmodule