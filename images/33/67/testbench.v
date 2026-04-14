`timescale 1ns/1ps

module comparator_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire A_eq;
    wire A_gt;
    wire A_lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_64bit dut (
        .A(A),
        .B(B),
        .A_eq(A_eq),
        .A_gt(A_gt),
        .A_lt(A_lt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: A == B (All Zeros)");
        A = 64'h0000000000000000;
        B = 64'h0000000000000000;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: A == B (All Ones)");
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: A > B (MSB differs)");
        A = 64'h8000000000000000;
        B = 64'h7FFFFFFFFFFFFFFF;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: A < B (MSB differs)");
        A = 64'h7FFFFFFFFFFFFFFF;
        B = 64'h8000000000000000;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: A > B (LSB differs)");
        A = 64'h0000000000000001;
        B = 64'h0000000000000000;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: A < B (LSB differs)");
        A = 64'h0000000000000000;
        B = 64'h0000000000000001;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: A > B (Middle bits)");
        A = 64'h0000FFFF00000000;
        B = 64'h0000EEEEFFFFFFFF;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: A < B (Middle bits)");
        A = 64'h1234567812345678;
        B = 64'h1234567812345679;
        #1;

        check_outputs(1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: A == B (Arbitrary Value)");
        A = 64'hA5A5A5A55A5A5A5A;
        B = 64'hA5A5A5A55A5A5A5A;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: A > B (Max vs Max-1)");
        A = 64'hFFFFFFFFFFFFFFFF;
        B = 64'hFFFFFFFFFFFFFFFE;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_64bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_A_eq;
        input expected_A_gt;
        input expected_A_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq === (expected_A_eq ^ A_eq ^ expected_A_eq) &&
                expected_A_gt === (expected_A_gt ^ A_gt ^ expected_A_gt) &&
                expected_A_lt === (expected_A_lt ^ A_lt ^ expected_A_lt)) begin
                $display("PASS");
                $display("  Outputs: A_eq=%b, A_gt=%b, A_lt=%b",
                         A_eq, A_gt, A_lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq=%b, A_gt=%b, A_lt=%b",
                         expected_A_eq, expected_A_gt, expected_A_lt);
                $display("  Got:      A_eq=%b, A_gt=%b, A_lt=%b",
                         A_eq, A_gt, A_lt);
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
