`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_0r0;
    reg i_0r1;
    reg i_1r;
    reg o_0a;
    reg reset;
    wire i_0a;
    wire i_1a;
    wire o_0r0;
    wire o_0r1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_0r0(i_0r0),
        .i_0r1(i_0r1),
        .i_1r(i_1r),
        .o_0a(o_0a),
        .reset(reset),
        .i_0a(i_0a),
        .i_1a(i_1a),
        .o_0r0(o_0r0),
        .o_0r1(o_0r1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset = 1;
            i_0r0 = 1; i_0r1 = 1; i_1r = 1; o_0a = 1;
            #10;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data 0 Join (i_0r0 and i_1r)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1; i_0r1 = 0; i_1r = 1; o_0a = 0;
            #10;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data 1 Join (i_0r1 and i_1r)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0; i_0r1 = 1; i_1r = 1; o_0a = 0;
            #10;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Full Handshake Acknowledge (Path 0)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1; i_0r1 = 0; i_1r = 1; o_0a = 1;
            #10;
            #1;

            check_outputs(1, 1, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Full Handshake Acknowledge (Path 1)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0; i_0r1 = 1; i_1r = 1; o_0a = 1;
            #10;
            #1;

            check_outputs(1, 1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Input Sync Check (i_0r0 only)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1; i_0r1 = 0; i_1r = 0; o_0a = 1;
            #10;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Input Sync Check (i_1r only)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0; i_0r1 = 0; i_1r = 1; o_0a = 1;
            #10;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Reset Mid-Operation", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1; i_0r1 = 0; i_1r = 1; o_0a = 0;
            #5;
            reset = 1;
            #10;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_i_0a;
        input expected_i_1a;
        input expected_o_0r0;
        input expected_o_0r1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_i_1a === (expected_i_1a ^ i_1a ^ expected_i_1a) &&
                expected_o_0r0 === (expected_o_0r0 ^ o_0r0 ^ expected_o_0r0) &&
                expected_o_0r1 === (expected_o_0r1 ^ o_0r1 ^ expected_o_0r1)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, i_1a=%b, o_0r0=%b, o_0r1=%b",
                         i_0a, i_1a, o_0r0, o_0r1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, i_1a=%b, o_0r0=%b, o_0r1=%b",
                         expected_i_0a, expected_i_1a, expected_o_0r0, expected_o_0r1);
                $display("  Got:      i_0a=%b, i_1a=%b, o_0r0=%b, o_0r1=%b",
                         i_0a, i_1a, o_0r0, o_0r1);
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
