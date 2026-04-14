module counter_2bit (
    input clk,
    input rst_n,
    output reg [1:0] count,
    output reg valid
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 2'b00;
            valid <= 1'b0;
        end else begin
            if (count == 2'b11) begin
                count <= 2'b00;
                valid <= 1'b1; // Max value reached
            end else begin
                count <= count + 1;
                valid <= 1'b0;
            end
        end
    end
endmodule