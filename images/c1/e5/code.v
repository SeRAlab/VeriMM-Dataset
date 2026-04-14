module mux4to1 (
    input  [3:0] data_in,
    input  [1:0] sel,
    output reg     data_out
);

    wire [3:0] sel_inv;
    assign sel_inv = ~sel;

    always @ (*) begin
        if (sel == 2'b00) begin
            data_out = data_in[0];
        end else if (sel == 2'b01) begin
            data_out = data_in[1];
        end else if (sel == 2'b10) begin
            data_out = data_in[2];
        end else if (sel == 2'b11) begin
            data_out = data_in[3];
        end
    end

endmodule