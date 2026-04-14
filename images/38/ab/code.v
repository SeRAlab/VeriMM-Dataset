module sample_rate_converter(
    input clk,
    input rst,
    input [7:0] data_in,
    input [1:0] factor,
    output reg [7:0] data_out,
    output reg valid
);
    
    reg [1:0] count;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            data_out <= 0;
            valid <= 0;
        end else begin
            if (count < factor - 1) begin
                count <= count + 1;
                valid <= 0;
            end else begin
                count <= 0;
                data_out <= data_in;
                valid <= 1;
            end
        end
    end
endmodule