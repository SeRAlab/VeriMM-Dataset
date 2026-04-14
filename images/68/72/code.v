module top_module(input A1, A2, A3, B1, B2, VPWR, VGND, VPB, VNB, output Y);reg [2:0] state;
    parameter IDLE = 3'b000;
    parameter TRANSITION_ONE = 3'b001;
    parameter TRANSITION_TWO = 3'b010;
    parameter TRANSITION_THREE = 3'b011;
    parameter TRANSITION_COMPLETE = 3'b100;

    always @(posedge VPWR) begin
        case(state)
            IDLE: begin
                if(A1==1'b0 && A2==1'b0 && A3==1'b0 && B1==1'b0 && B2==1'b0) begin
                    state <= TRANSITION_ONE;
                end
            end
            TRANSITION_ONE: begin
                if(A1==1'b1 && A2==1'b1 && A3==1'b1 && B1==1'b1 && B2==1'b1) begin
                    state <= TRANSITION_TWO;
                end
            end
            TRANSITION_TWO: begin
                if(A1==1'b0 && A2==1'b0 && A3==1'b0 && B1==1'b0 && B2==1'b0) begin
                    state <= TRANSITION_THREE;
                end
            end
            TRANSITION_THREE: begin
                if(VPWR==1'b1 && VPB==1'b1 && VNB==1'b1 && VGND==1'b1 && B2==1'b1 && B1==1'b1 && A3==1'b1 && A2==1'b1 && A1==1'b1) begin
                    state <= TRANSITION_COMPLETE;
                end
            end
            TRANSITION_COMPLETE: begin
                state <= IDLE;
            end
        endcase
    end

    assign Y = (state == TRANSITION_COMPLETE) ? 1'b1 : 1'b0;

endmodule