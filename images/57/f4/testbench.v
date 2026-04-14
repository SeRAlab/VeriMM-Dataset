`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    wire eq;
    wire gt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .eq(eq),
        .gt(gt)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 3'b000; B = 3'b000;
        $display("Test %0d: A=%d, B=%d (Equal, 0)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 3'b111; B = 3'b111;
        $display("Test %0d: A=%d, B=%d (Equal, 7)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 3'b011; B = 3'b011;
        $display("Test %0d: A=%d, B=%d (Equal, 3)", test_num, A, B);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 3'b101; B = 3'b010;
        $display("Test %0d: A=%d, B=%d (A > B, 5 > 2)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 3'b111; B = 3'b000;
        $display("Test %0d: A=%d, B=%d (A > B, Max vs Min)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 3'b001; B = 3'b000;
        $display("Test %0d: A=%d, B=%d (A > B, increment check)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 3'b010; B = 3'b110;
        $display("Test %0d: A=%d, B=%d (A < B, 2 < 6)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 3'b000; B = 3'b111;
        $display("Test %0d: A=%d, B=%d (A < B, Min vs Max)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 3'b110; B = 3'b111;
        $display("Test %0d: A=%d, B=%d (A < B, decrement check)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 3'b100; B = 3'b101;
        $display("Test %0d: A=%d, B=%d (A < B, bit difference)", test_num, A, B);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_eq;
        input expected_gt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eq === (expected_eq ^ eq ^ expected_eq) &&
                expected_gt === (expected_gt ^ gt ^ expected_gt)) begin
                $display("PASS");
                $display("  Outputs: eq=%b, gt=%b",
                         eq, gt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eq=%b, gt=%b",
                         expected_eq, expected_gt);
                $display("  Got:      eq=%b, gt=%b",
                         eq, gt);
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
