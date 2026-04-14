module deserializer (
    input clk,
    input rst,
    input [7:0] serial_in,
    output reg [31:0] parallel_out,
    output reg valid
);
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            parallel_out <= 0;
            valid <= 0;
        end else begin
            if (count < 4) begin
                parallel_out <= {parallel_out[23:0], serial_in};
                count <= count + 1;
                valid <= 0;
            end else begin
                valid <= 1;
            end
        end
    end
endmodule