module state_space_controller (
    input clk,
    input rst,
    input [3:0] state_input,
    output reg [3:0] control_output
);
    reg [3:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 4'b0000;
        end else begin
            case (state)
                4'b0000: state <= (state_input[0]) ? 4'b0001 : 4'b0000;
                4'b0001: state <= (state_input[0]) ? 4'b0010 : 4'b0000;
                4'b0010: state <= (state_input[0]) ? 4'b0011 : 4'b0001;
                4'b0011: state <= (state_input[0]) ? 4'b0000 : 4'b0010;
                default: state <= 4'b0000;
            endcase
        end
    end

    always @(*) begin
        control_output = state;
    end
endmodule