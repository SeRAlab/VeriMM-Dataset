`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] a00;
    reg [8:0] a01;
    reg [8:0] a02;
    reg [8:0] a10;
    reg [8:0] a11;
    reg [8:0] a12;
    reg [8:0] a20;
    reg [8:0] a21;
    reg [8:0] a22;
    wire [8:0] inv00;
    wire [8:0] inv01;
    wire [8:0] inv02;
    wire [8:0] inv10;
    wire [8:0] inv11;
    wire [8:0] inv12;
    wire [8:0] inv20;
    wire [8:0] inv21;
    wire [8:0] inv22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .a00(a00),
        .a01(a01),
        .a02(a02),
        .a10(a10),
        .a11(a11),
        .a12(a12),
        .a20(a20),
        .a21(a21),
        .a22(a22),
        .inv00(inv00),
        .inv01(inv01),
        .inv02(inv02),
        .inv10(inv10),
        .inv11(inv11),
        .inv12(inv12),
        .inv20(inv20),
        .inv21(inv21),
        .inv22(inv22)
    );
    task testcase001;

    begin
        $display("Running Testcase 001: Identity Matrix");
        a00 = 9'h001; a01 = 9'h000; a02 = 9'h000;
        a10 = 9'h000; a11 = 9'h001; a12 = 9'h000;
        a20 = 9'h000; a21 = 9'h000; a22 = 9'h001;
        #1;

        check_outputs(9'h001, 9'h000, 9'h000,
                      9'h000, 9'h001, 9'h000,
                      9'h000, 9'h000, 9'h001);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Zero Matrix (Singular)");
        a00 = 9'h000; a01 = 9'h000; a02 = 9'h000;
        a10 = 9'h000; a11 = 9'h000; a12 = 9'h000;
        a20 = 9'h000; a21 = 9'h000; a22 = 9'h000;
        #1;

        check_outputs(9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Matrix with Det=1");
        a00 = 9'h001; a01 = 9'h000; a02 = 9'h001;
        a10 = 9'h000; a11 = 9'h001; a12 = 9'h000;
        a20 = 9'h000; a21 = 9'h000; a22 = 9'h001;
        #1;

        check_outputs(9'h001, 9'h000, 9'h1FF,
                      9'h000, 9'h001, 9'h000,
                      9'h000, 9'h000, 9'h001);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Permutation Matrix (Det=-1)");
        a00 = 9'h000; a01 = 9'h001; a02 = 9'h000;
        a10 = 9'h001; a11 = 9'h000; a12 = 9'h000;
        a20 = 9'h000; a21 = 9'h000; a22 = 9'h001;
        #1;

        check_outputs(9'h000, 9'h001, 9'h000,
                      9'h001, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h001);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Linear Dependence (Det=0)");
        a00 = 9'h001; a01 = 9'h002; a02 = 9'h003;
        a10 = 9'h001; a11 = 9'h002; a12 = 9'h003;
        a20 = 9'h004; a21 = 9'h005; a22 = 9'h006;
        #1;

        check_outputs(9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000);
    end
        endtask

    task testcase006;

    begin
        $display("Running Testcase 006: Upper Triangular Det=1");
        a00 = 9'h001; a01 = 9'h002; a02 = 9'h003;
        a10 = 9'h000; a11 = 9'h001; a12 = 9'h004;
        a20 = 9'h000; a21 = 9'h000; a22 = 9'h001;
        #1;

        check_outputs(9'h001, 9'h1FE, 9'h005,
                      9'h000, 9'h001, 9'h1FC,
                      9'h000, 9'h000, 9'h001);
    end
        endtask

    task testcase007;

    begin
        $display("Running Testcase 007: Lower Triangular Det=1");
        a00 = 9'h001; a01 = 9'h000; a02 = 9'h000;
        a10 = 9'h002; a11 = 9'h001; a12 = 9'h000;
        a20 = 9'h003; a21 = 9'h004; a22 = 9'h001;
        #1;

        check_outputs(9'h001, 9'h000, 9'h000,
                      9'h1FE, 9'h001, 9'h000,
                      9'h005, 9'h1FC, 9'h001);
    end
        endtask

    task testcase008;

    begin
        $display("Running Testcase 008: Singular (Row 0=0)");
        a00 = 9'h000; a01 = 9'h000; a02 = 9'h000;
        a10 = 9'h005; a11 = 9'h002; a12 = 9'h001;
        a20 = 9'h007; a21 = 9'h003; a22 = 9'h004;
        #1;

        check_outputs(9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000,
                      9'h000, 9'h000, 9'h000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [8:0] expected_inv00;
        input [8:0] expected_inv01;
        input [8:0] expected_inv02;
        input [8:0] expected_inv10;
        input [8:0] expected_inv11;
        input [8:0] expected_inv12;
        input [8:0] expected_inv20;
        input [8:0] expected_inv21;
        input [8:0] expected_inv22;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inv00 === (expected_inv00 ^ inv00 ^ expected_inv00) &&
                expected_inv01 === (expected_inv01 ^ inv01 ^ expected_inv01) &&
                expected_inv02 === (expected_inv02 ^ inv02 ^ expected_inv02) &&
                expected_inv10 === (expected_inv10 ^ inv10 ^ expected_inv10) &&
                expected_inv11 === (expected_inv11 ^ inv11 ^ expected_inv11) &&
                expected_inv12 === (expected_inv12 ^ inv12 ^ expected_inv12) &&
                expected_inv20 === (expected_inv20 ^ inv20 ^ expected_inv20) &&
                expected_inv21 === (expected_inv21 ^ inv21 ^ expected_inv21) &&
                expected_inv22 === (expected_inv22 ^ inv22 ^ expected_inv22)) begin
                $display("PASS");
                $display("  Outputs: inv00=%h, inv01=%h, inv02=%h, inv10=%h, inv11=%h, inv12=%h, inv20=%h, inv21=%h, inv22=%h",
                         inv00, inv01, inv02, inv10, inv11, inv12, inv20, inv21, inv22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv00=%h, inv01=%h, inv02=%h, inv10=%h, inv11=%h, inv12=%h, inv20=%h, inv21=%h, inv22=%h",
                         expected_inv00, expected_inv01, expected_inv02, expected_inv10, expected_inv11, expected_inv12, expected_inv20, expected_inv21, expected_inv22);
                $display("  Got:      inv00=%h, inv01=%h, inv02=%h, inv10=%h, inv11=%h, inv12=%h, inv20=%h, inv21=%h, inv22=%h",
                         inv00, inv01, inv02, inv10, inv11, inv12, inv20, inv21, inv22);
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
