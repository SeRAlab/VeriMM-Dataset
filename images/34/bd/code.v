module ARQ_System (
    input [4:0] received_data,
    input valid,
    output reg [4:0] corrected_data,
    output reg request,
    output reg [2:0] retransmission_count,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            corrected_data <= 5'b00000;
            request <= 0;
            retransmission_count <= 3'b000;
        end else if (valid) begin
            corrected_data <= received_data;
            request <= 0; // No request needed
        end else begin
            request <= 1; // Request retransmission
            retransmission_count <= retransmission_count + 1; // Increment count
        end
    end
endmodule