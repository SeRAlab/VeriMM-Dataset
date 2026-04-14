module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input EN,
    output reg [3:0] Y
);// Voltage supply signals (not used in simulation, comment out if unnecessary)
    // supply1 VPWR;
    // supply0 VGND;

    wire en_bar;
    wire a_and_out, b_and_out;
    wire [3:0] bc_mux_out, d_bc_mux_out;

    // Inverter for EN signal
    assign en_bar = ~EN;

    // AND gate for A[0] and A[1]
    assign a_and_out = A[0] & A[1];

    // AND gate for A[2] and A[3]
    assign b_and_out = A[2] & A[3];

    // MUX for B and C based on a_and_out
    assign bc_mux_out = a_and_out ? B : C;

    // MUX for D and bc_mux_out based on b_and_out
    assign d_bc_mux_out = b_and_out ? bc_mux_out : D;

    always @(*) begin
        if (EN == 1'b1) begin
            if (A == 4'b0000) begin
                Y <= B;
            end else if (A == 4'b1111) begin
                Y <= C;
            end else begin
                Y <= A;
            end
        end else begin
            Y <= d_bc_mux_out;
        end
    end

endmodule