`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] cs;
    reg extra;
    reg pipeline_enabled;
    wire EXEC1;
    wire EXEC2;
    wire FETCH;
    wire [2:0] NS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .extra(extra),
        .pipeline_enabled(pipeline_enabled),
        .EXEC1(EXEC1),
        .EXEC2(EXEC2),
        .FETCH(FETCH),
        .NS(NS)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: State 0 (FETCH) - Default Mode", test_num);
            cs = 3'b000;
            extra = 0;
            pipeline_enabled = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 3'b001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: State 1 (EXEC1) - Default Mode", test_num);
            cs = 3'b001;
            extra = 0;
            pipeline_enabled = 0;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: State 2 (EXEC2) - Default Mode", test_num);
            cs = 3'b010;
            extra = 0;
            pipeline_enabled = 0;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: State 1 with Conditional 'extra' Transition", test_num);
            cs = 3'b001;
            extra = 1;
            pipeline_enabled = 0;


            #1;



            check_outputs(1'b1, 1'b0, 1'b0, 3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Pipeline Enabled - Early Fetch Check", test_num);
            cs = 3'b010;
            extra = 0;
            pipeline_enabled = 1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: State 3 (Boundary/Idle State)", test_num);
            cs = 3'b011;
            extra = 0;
            pipeline_enabled = 0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 3'b000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: High State Indices (4-7) Stability", test_num);
            cs = 3'b111;
            extra = 1;
            pipeline_enabled = 1;

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
        input expected_EXEC1;
        input expected_EXEC2;
        input expected_FETCH;
        input [2:0] expected_NS;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXEC1 === (expected_EXEC1 ^ EXEC1 ^ expected_EXEC1) &&
                expected_EXEC2 === (expected_EXEC2 ^ EXEC2 ^ expected_EXEC2) &&
                expected_FETCH === (expected_FETCH ^ FETCH ^ expected_FETCH) &&
                expected_NS === (expected_NS ^ NS ^ expected_NS)) begin
                $display("PASS");
                $display("  Outputs: EXEC1=%b, EXEC2=%b, FETCH=%b, NS=%h",
                         EXEC1, EXEC2, FETCH, NS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXEC1=%b, EXEC2=%b, FETCH=%b, NS=%h",
                         expected_EXEC1, expected_EXEC2, expected_FETCH, expected_NS);
                $display("  Got:      EXEC1=%b, EXEC2=%b, FETCH=%b, NS=%h",
                         EXEC1, EXEC2, FETCH, NS);
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
