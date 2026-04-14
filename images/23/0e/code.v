module packet_filter (
    input [7:0] packet_id,
    output reg allowed
);
    // Define the allowed packet identifiers
    parameter ALLOWED_ID_0 = 8'hA1;
    parameter ALLOWED_ID_1 = 8'hB2;
    parameter ALLOWED_ID_2 = 8'hC3;
    parameter ALLOWED_ID_3 = 8'hD4;
    parameter ALLOWED_ID_4 = 8'hE5;

    always @(*) begin
        case (packet_id)
            ALLOWED_ID_0: allowed = 1'b1;
            ALLOWED_ID_1: allowed = 1'b1;
            ALLOWED_ID_2: allowed = 1'b1;
            ALLOWED_ID_3: allowed = 1'b1;
            ALLOWED_ID_4: allowed = 1'b1;
            default: allowed = 1'b0;
        endcase
    end
endmodule