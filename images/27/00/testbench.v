`timescale 1ns/1ps

module nearest_neighbor_interpolation_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pixel00;
    reg [7:0] pixel01;
    reg [7:0] pixel10;
    reg [7:0] pixel11;
    wire [7:0] out00;
    wire [7:0] out01;
    wire [7:0] out02;
    wire [7:0] out03;
    wire [7:0] out10;
    wire [7:0] out11;
    wire [7:0] out12;
    wire [7:0] out13;
    wire [7:0] out20;
    wire [7:0] out21;
    wire [7:0] out22;
    wire [7:0] out23;
    wire [7:0] out30;
    wire [7:0] out31;
    wire [7:0] out32;
    wire [7:0] out33;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    nearest_neighbor_interpolation dut (
        .pixel00(pixel00),
        .pixel01(pixel01),
        .pixel10(pixel10),
        .pixel11(pixel11),
        .out00(out00),
        .out01(out01),
        .out02(out02),
        .out03(out03),
        .out10(out10),
        .out11(out11),
        .out12(out12),
        .out13(out13),
        .out20(out20),
        .out21(out21),
        .out22(out22),
        .out23(out23),
        .out30(out30),
        .out31(out31),
        .out32(out32),
        .out33(out33)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All pixels zero (Black Image)");
            pixel00 = 8'h00;
            pixel01 = 8'h00;
            pixel10 = 8'h00;
            pixel11 = 8'h00;

            #1;


            check_outputs(
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00,
                8'h00, 8'h00, 8'h00, 8'h00
            );
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All pixels full (White Image)");
            pixel00 = 8'hFF;
            pixel01 = 8'hFF;
            pixel10 = 8'hFF;
            pixel11 = 8'hFF;

            #1;


            check_outputs(
                8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF,
                8'hFF, 8'hFF, 8'hFF, 8'hFF
            );
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Distinct values for each input quadrant");
            pixel00 = 8'h11;
            pixel01 = 8'h22;
            pixel10 = 8'h33;
            pixel11 = 8'h44;






            #1;







            check_outputs(
                8'h11, 8'h11, 8'h22, 8'h22,
                8'h11, 8'h11, 8'h22, 8'h22,
                8'h33, 8'h33, 8'h44, 8'h44,
                8'h33, 8'h33, 8'h44, 8'h44
            );
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Checkerboard pattern");
            pixel00 = 8'hAA;
            pixel01 = 8'h55;
            pixel10 = 8'h55;
            pixel11 = 8'hAA;

            #1;


            check_outputs(
                8'hAA, 8'hAA, 8'h55, 8'h55,
                8'hAA, 8'hAA, 8'h55, 8'h55,
                8'h55, 8'h55, 8'hAA, 8'hAA,
                8'h55, 8'h55, 8'hAA, 8'hAA
            );
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Gradient pattern");
            pixel00 = 8'h10;
            pixel01 = 8'h40;
            pixel10 = 8'h70;
            pixel11 = 8'hA0;

            #1;


            check_outputs(
                8'h10, 8'h10, 8'h40, 8'h40,
                8'h10, 8'h10, 8'h40, 8'h40,
                8'h70, 8'h70, 8'hA0, 8'hA0,
                8'h70, 8'h70, 8'hA0, 8'hA0
            );
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("nearest_neighbor_interpolation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [7:0] expected_out00;
        input [7:0] expected_out01;
        input [7:0] expected_out02;
        input [7:0] expected_out03;
        input [7:0] expected_out10;
        input [7:0] expected_out11;
        input [7:0] expected_out12;
        input [7:0] expected_out13;
        input [7:0] expected_out20;
        input [7:0] expected_out21;
        input [7:0] expected_out22;
        input [7:0] expected_out23;
        input [7:0] expected_out30;
        input [7:0] expected_out31;
        input [7:0] expected_out32;
        input [7:0] expected_out33;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out00 === (expected_out00 ^ out00 ^ expected_out00) &&
                expected_out01 === (expected_out01 ^ out01 ^ expected_out01) &&
                expected_out02 === (expected_out02 ^ out02 ^ expected_out02) &&
                expected_out03 === (expected_out03 ^ out03 ^ expected_out03) &&
                expected_out10 === (expected_out10 ^ out10 ^ expected_out10) &&
                expected_out11 === (expected_out11 ^ out11 ^ expected_out11) &&
                expected_out12 === (expected_out12 ^ out12 ^ expected_out12) &&
                expected_out13 === (expected_out13 ^ out13 ^ expected_out13) &&
                expected_out20 === (expected_out20 ^ out20 ^ expected_out20) &&
                expected_out21 === (expected_out21 ^ out21 ^ expected_out21) &&
                expected_out22 === (expected_out22 ^ out22 ^ expected_out22) &&
                expected_out23 === (expected_out23 ^ out23 ^ expected_out23) &&
                expected_out30 === (expected_out30 ^ out30 ^ expected_out30) &&
                expected_out31 === (expected_out31 ^ out31 ^ expected_out31) &&
                expected_out32 === (expected_out32 ^ out32 ^ expected_out32) &&
                expected_out33 === (expected_out33 ^ out33 ^ expected_out33)) begin
                $display("PASS");
                $display("  Outputs: out00=%h, out01=%h, out02=%h, out03=%h, out10=%h, out11=%h, out12=%h, out13=%h, out20=%h, out21=%h, out22=%h, out23=%h, out30=%h, out31=%h, out32=%h, out33=%h",
                         out00, out01, out02, out03, out10, out11, out12, out13, out20, out21, out22, out23, out30, out31, out32, out33);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out00=%h, out01=%h, out02=%h, out03=%h, out10=%h, out11=%h, out12=%h, out13=%h, out20=%h, out21=%h, out22=%h, out23=%h, out30=%h, out31=%h, out32=%h, out33=%h",
                         expected_out00, expected_out01, expected_out02, expected_out03, expected_out10, expected_out11, expected_out12, expected_out13, expected_out20, expected_out21, expected_out22, expected_out23, expected_out30, expected_out31, expected_out32, expected_out33);
                $display("  Got:      out00=%h, out01=%h, out02=%h, out03=%h, out10=%h, out11=%h, out12=%h, out13=%h, out20=%h, out21=%h, out22=%h, out23=%h, out30=%h, out31=%h, out32=%h, out33=%h",
                         out00, out01, out02, out03, out10, out11, out12, out13, out20, out21, out22, out23, out30, out31, out32, out33);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
