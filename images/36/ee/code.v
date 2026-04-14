module sd_card_controller (
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire read_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] stored_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stored_data <= 8'b0;
            data_out <= 8'b0;
        end else begin
            if (write_en) begin
                stored_data <= data_in;
            end
            if (read_en) begin
                data_out <= stored_data;
            end
        end
    end
endmodule