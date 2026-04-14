`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Extra;
    reg Loop;
    reg [2:0] cs;
    wire exec1;
    wire exec2;
    wire fetch;
    wire [2:0] ns;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Extra(Extra),
        .Loop(Loop),
        .cs(cs),
        .exec1(exec1),
        .exec2(exec2),
        .fetch(fetch),
        .ns(ns)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: CS=000, Extra=0", test_num);
            cs = 3'b000; Extra = 1'b0; Loop = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 3'b010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: CS=000, Extra=1", test_num);
            cs = 3'b000; Extra = 1'b1; Loop = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: CS=001", test_num);
            cs = 3'b001; Extra = 1'b0; Loop = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: CS=010 (Exec1)", test_num);
            cs = 3'b010; Extra = 1'b0; Loop = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: CS=011 (Exec2), Loop=0", test_num);
            cs = 3'b011; Extra = 1'b0; Loop = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 3'b100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: CS=011 (Exec2), Loop=1", test_num);
            cs = 3'b011; Extra = 1'b0; Loop = 1'b1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: CS=100", test_num);
            cs = 3'b100; Extra = 1'b0; Loop = 1'b0;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
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
        input expected_exec1;
        input expected_exec2;
        input expected_fetch;
        input [2:0] expected_ns;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exec1 === (expected_exec1 ^ exec1 ^ expected_exec1) &&
                expected_exec2 === (expected_exec2 ^ exec2 ^ expected_exec2) &&
                expected_fetch === (expected_fetch ^ fetch ^ expected_fetch) &&
                expected_ns === (expected_ns ^ ns ^ expected_ns)) begin
                $display("PASS");
                $display("  Outputs: exec1=%b, exec2=%b, fetch=%b, ns=%h",
                         exec1, exec2, fetch, ns);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exec1=%b, exec2=%b, fetch=%b, ns=%h",
                         expected_exec1, expected_exec2, expected_fetch, expected_ns);
                $display("  Got:      exec1=%b, exec2=%b, fetch=%b, ns=%h",
                         exec1, exec2, fetch, ns);
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
