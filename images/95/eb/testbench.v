`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg light1;
    reg light2;
    reg light3;
    wire [3:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .light1(light1),
        .light2(light2),
        .light3(light3),
        .LED(LED)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All lights inactive (000)", test_num);
            light1 = 0; light2 = 0; light3 = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only light1 active (100)", test_num);
            light1 = 1; light2 = 0; light3 = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only light2 active (010)", test_num);
            light1 = 0; light2 = 1; light3 = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check: light2 and light1 active (110)", test_num);
            light1 = 1; light2 = 1; light3 = 0;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only light3 active (001)", test_num);
            light1 = 0; light2 = 0; light3 = 1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check: light3 and light1 active (101)", test_num);
            light1 = 1; light2 = 0; light3 = 1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check: light3 and light2 active (011)", test_num);
            light1 = 0; light2 = 1; light3 = 1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Priority check: All lights active (111)", test_num);
            light1 = 1; light2 = 1; light3 = 1;
            #1;

            check_outputs(4'b0111);
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
        input [3:0] expected_LED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
