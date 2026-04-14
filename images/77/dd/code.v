module top_module(
    input wire [3:0] priority_enc_out,
    input wire [3:0] comb_circuit_out,
    output reg [3:0] max_out
);// Comparator functional module
    always @(*) begin
        if (priority_enc_out > comb_circuit_out) begin
            max_out = priority_enc_out;
        end else begin
            max_out = comb_circuit_out;
        end
    end

endmodule