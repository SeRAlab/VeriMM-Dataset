module qam_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in, // 4 bits: 2 bits for I, 2 bits for Q
    output reg [7:0] qam_out // 8 bits output
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            qam_out <= 8'b0;
        end else begin
            qam_out <= {data_in[3:2], data_in[1:0]}; // Combine I and Q
        end
    end
endmodule