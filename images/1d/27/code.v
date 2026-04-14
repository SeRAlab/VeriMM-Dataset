module hazard_detection_counter (
    input wire clk,
    input wire reset,
    output reg [1:0] count
);
    reg [1:0] next_count;

    always @(*) begin
        if (reset) begin
            next_count = 2'b00;
        end else begin
            case (count)
                2'b00: next_count = 2'b01;
                2'b01: next_count = 2'b10;
                2'b10: next_count = 2'b11;
                2'b11: next_count = 2'b00;
                default: next_count = 2'b00;
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 2'b00;
        end else begin
            count <= next_count;
        end
    end
endmodule