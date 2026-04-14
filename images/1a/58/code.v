module ARQ_system (
    input clk,
    input rst_n,
    input [4:0] data_in,
    input parity_in,
    output reg valid,
    output reg retransmit
);
    reg calculated_parity;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid <= 0;
            retransmit <= 0;
        end else begin
            // Calculate parity: XOR all bits of data
            calculated_parity = data_in[0] ^ data_in[1] ^ data_in[2] ^ data_in[3] ^ data_in[4];
            if (calculated_parity == parity_in) begin
                valid <= 1;
                retransmit <= 0;
            end else begin
                valid <= 0;
                retransmit <= 1; // Request retransmission
            end
        end
    end
endmodule