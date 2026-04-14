module current_sensor (
    input [4:0] current_input,
    output reg [2:0] output_status
);
    always @(*) begin
        if (current_input <= 5'd15) begin
            output_status = 3'b000;
        end else if (current_input <= 5'd31) begin
            output_status = 3'b001;
        end else if (current_input <= 5'd47) begin
            output_status = 3'b010;
        end else if (current_input <= 5'd63) begin
            output_status = 3'b011;
        end else begin
            output_status = 3'b111; // overload
        end
    end
endmodule