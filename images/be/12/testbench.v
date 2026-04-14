`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg i_0r0;
    reg i_0r1;
    reg o_0a;
    reg reset;
    wire i_0a;
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
        .o_0a(o_0a),
        .reset(reset),
        .i_0a(i_0a),
        .o_0r0(o_0r0),
        .o_0r1(o_0r1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset logic check (Reset Active)", test_num);

            reset = 1;
            i_0r0 = 1;
            i_0r1 = 1;
            o_0a = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 latching and OR logic", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1;
            i_0r1 = 0;
            o_0a = 0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 1 latching and OR logic", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0;
            i_0r1 = 1;
            o_0a = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Feedback gating logic (o_0a High)", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 1;
            i_0r1 = 1;
            o_0a = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0;
            i_0r1 = 0;
            o_0a = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset override during active inputs", test_num);
            reset = 0;
            i_0r0 = 1;
            i_0r1 = 1;
            o_0a = 0;
            #5;
            reset = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Feedback gating with only one register active", test_num);
            reset = 1; #5; reset = 0;
            i_0r0 = 0;
            i_0r1 = 1;
            o_0a = 1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1);
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
        input expected_o_0r0;
        input expected_o_0r1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_i_0a === (expected_i_0a ^ i_0a ^ expected_i_0a) &&
                expected_o_0r0 === (expected_o_0r0 ^ o_0r0 ^ expected_o_0r0) &&
                expected_o_0r1 === (expected_o_0r1 ^ o_0r1 ^ expected_o_0r1)) begin
                $display("PASS");
                $display("  Outputs: i_0a=%b, o_0r0=%b, o_0r1=%b",
                         i_0a, o_0r0, o_0r1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: i_0a=%b, o_0r0=%b, o_0r1=%b",
                         expected_i_0a, expected_o_0r0, expected_o_0r1);
                $display("  Got:      i_0a=%b, o_0r0=%b, o_0r1=%b",
                         i_0a, o_0r0, o_0r1);
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
