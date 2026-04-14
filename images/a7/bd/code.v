module priority_encoder(
    input [2:0] in,
    input enable,
    output reg [1:0] out
);

    // Always block triggered on changes to the inputs
    always @(*) begin
        if (enable) begin
            if (in[2]) begin
                out = 2'b10;  // Highest priority
            end else if (in[1]) begin
                out = 2'b01;
            end else if (in[0]) begin
                out = 2'b00;
            end else begin
                out = 2'b00;  // Default case when no inputs are high
            end
        end else begin
            out = 2'b00;  // Output is zero when enable is low
        end
    end

endmodule