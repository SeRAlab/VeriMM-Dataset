`timescale 1ns/1ps

module LU_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A11;
    reg [31:0] A12;
    reg [31:0] A21;
    reg [31:0] A22;
    wire [31:0] L11;
    wire [31:0] L21;
    wire [31:0] L22;
    wire [31:0] U11;
    wire [31:0] U12;
    wire [31:0] U22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_decomposition dut (
        .A11(A11),
        .A12(A12),
        .A21(A21),
        .A22(A22),
        .L11(L11),
        .L21(L21),
        .L22(L22),
        .U11(U11),
        .U12(U12),
        .U22(U22)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Identity Matrix", test_num);
        A11 = 32'd1; A12 = 32'd0;
        A21 = 32'd0; A22 = 32'd1;
        #1;

        check_outputs(
            32'd1, 32'd0, 32'd1,
            32'd1, 32'd0, 32'd1
        );
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Simple Integer decomposition", test_num);
        A11 = 32'd2; A12 = 32'd4;
        A21 = 32'd6; A22 = 32'd15;
        #1;

        check_outputs(
            32'd1, 32'd3, 32'd1,
            32'd2, 32'd4, 32'd3
        );
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Larger integer values", test_num);
        A11 = 32'd4;  A12 = 32'd8;
        A21 = 32'd12; A22 = 32'd30;
        #1;

        check_outputs(
            32'd1, 32'd3, 32'd1,
            32'd4, 32'd8, 32'd6
        );
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Negative input values", test_num);
        A11 = 32'sd2; A12 = -32'sd2;
        A21 = 32'sd4; A22 = 32'sd1;
        #1;

        check_outputs(
            32'sd1, 32'sd2, 32'sd1,
            32'sd2, -32'sd2, 32'sd5
        );
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Negative result in U22", test_num);
        A11 = 32'd5;  A12 = 32'd10;
        A21 = 32'd10; A22 = 32'd5;
        #1;

        check_outputs(
            32'sd1, 32'sd2, 32'sd1,
            32'sd5, 32'sd10, -32'sd15
        );
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Upper Triangular input", test_num);
        A11 = 32'd1; A12 = 32'd5;
        A21 = 32'd0; A22 = 32'd2;
        #1;

        check_outputs(
            32'd1, 32'd0, 32'd1,
            32'd1, 32'd5, 32'd2
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
        $display("LU_decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_L11;
        input [31:0] expected_L21;
        input [31:0] expected_L22;
        input [31:0] expected_U11;
        input [31:0] expected_U12;
        input [31:0] expected_U22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L11 === (expected_L11 ^ L11 ^ expected_L11) &&
                expected_L21 === (expected_L21 ^ L21 ^ expected_L21) &&
                expected_L22 === (expected_L22 ^ L22 ^ expected_L22) &&
                expected_U11 === (expected_U11 ^ U11 ^ expected_U11) &&
                expected_U12 === (expected_U12 ^ U12 ^ expected_U12) &&
                expected_U22 === (expected_U22 ^ U22 ^ expected_U22)) begin
                $display("PASS");
                $display("  Outputs: L11=%h, L21=%h, L22=%h, U11=%h, U12=%h, U22=%h",
                         L11, L21, L22, U11, U12, U22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L11=%h, L21=%h, L22=%h, U11=%h, U12=%h, U22=%h",
                         expected_L11, expected_L21, expected_L22, expected_U11, expected_U12, expected_U22);
                $display("  Got:      L11=%h, L21=%h, L22=%h, U11=%h, U12=%h, U22=%h",
                         L11, L21, L22, U11, U12, U22);
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
