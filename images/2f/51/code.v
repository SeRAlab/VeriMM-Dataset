module temp_shutdown (
    input [7:0] temp,
    input reset,
    output reg shutdown
);
    always @(posedge reset or posedge temp[7]) begin
        if (reset) begin
            shutdown <= 0;
        end else if (temp > 8'd75) begin
            shutdown <= 1;
        end
    end
endmodule