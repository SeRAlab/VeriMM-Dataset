module divide_by_2 (
    input clk,
    input reset,
    input data_in,
    output reg data_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
        end else begin
            data_out <= data_in ^ data_out; // Toggle output on data input
        end
    end
endmodule