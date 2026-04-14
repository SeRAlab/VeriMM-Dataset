module ARQ_Error_Correction (
    input wire [4:0] data_in,
    input wire ack,
    input wire clk,
    input wire reset,
    output reg [4:0] data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 5'b00000;
        end else if (ack) begin
            data_out <= data_in;
        end
        // If ack is low, retain the previous value of data_out
    end
endmodule