module voltage_regulator (
    input wire clk,
    input wire rst,
    input wire [7:0] ref_voltage,
    input wire [7:0] control_voltage,
    output reg [7:0] output_voltage
);

    reg [1:0] state;

    parameter IDLE = 2'b00;
    parameter REGULATE = 2'b01;
    parameter MAX_LIMIT = 8'hFF; // Maximum output voltage limit

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            output_voltage <= 8'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (control_voltage != 8'b0)
                        state <= REGULATE;
                end
                REGULATE: begin
                    if (ref_voltage <= MAX_LIMIT) 
                        output_voltage <= ref_voltage;
                    else 
                        output_voltage <= MAX_LIMIT;
                    state <= IDLE; // Return to IDLE after regulation
                end
            endcase
        end
    end
endmodule