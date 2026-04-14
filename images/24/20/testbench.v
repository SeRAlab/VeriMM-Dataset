`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    wire [15:0] q1x;
    wire [15:0] q1y;
    wire [15:0] q2x;
    wire [15:0] q2y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .q1x(q1x),
        .q1y(q1y),
        .q2x(q2x),
        .q2y(q2y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Matrix", test_num);
        a11 = 16'h7FFF; a12 = 16'h0000;
        a21 = 16'h0000; a22 = 16'h7FFF;
        #1;

        check_outputs(16'h7FFF, 16'h0000, 16'h0000, 16'h7FFF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Scaled Identity Matrix", test_num);
        a11 = 16'h4000; a12 = 16'h0000;
        a21 = 16'h0000; a22 = 16'h4000;
        #1;

        check_outputs(16'h7FFF, 16'h0000, 16'h0000, 16'h7FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Permutation Matrix", test_num);
        a11 = 16'h0000; a12 = 16'h7FFF;
        a21 = 16'h7FFF; a22 = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h7FFF, 16'h7FFF, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Matrix", test_num);
        a11 = 16'h0000; a12 = 16'h0000;
        a21 = 16'h0000; a22 = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: First Vector Zero", test_num);
        a11 = 16'h0000; a12 = 16'h3000;
        a21 = 16'h0000; a22 = 16'h0000;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h7FFF, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 45 Degree Rotation", test_num);
        a11 = 16'h2000; a12 = 16'hE000;
        a21 = 16'h2000; a22 = 16'h2000;
        #1;

        check_outputs(16'h5A82, 16'h5A82, 16'hA57E, 16'h5A82);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Linearly Dependent Columns", test_num);
        a11 = 16'h4000; a12 = 16'h7FFF;
        a21 = 16'h0000; a22 = 16'h0000;
        #1;

        check_outputs(16'h7FFF, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qr_decomposition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_q1x;
        input [15:0] expected_q1y;
        input [15:0] expected_q2x;
        input [15:0] expected_q2y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1x === (expected_q1x ^ q1x ^ expected_q1x) &&
                expected_q1y === (expected_q1y ^ q1y ^ expected_q1y) &&
                expected_q2x === (expected_q2x ^ q2x ^ expected_q2x) &&
                expected_q2y === (expected_q2y ^ q2y ^ expected_q2y)) begin
                $display("PASS");
                $display("  Outputs: q1x=%h, q1y=%h, q2x=%h, q2y=%h",
                         q1x, q1y, q2x, q2y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1x=%h, q1y=%h, q2x=%h, q2y=%h",
                         expected_q1x, expected_q1y, expected_q2x, expected_q2y);
                $display("  Got:      q1x=%h, q1y=%h, q2x=%h, q2y=%h",
                         q1x, q1y, q2x, q2y);
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
