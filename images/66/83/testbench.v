`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg io_input;
    reg reset;
    wire io_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_input(io_input),
        .reset(reset),
        .io_result(io_result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: io_input = 0", test_num);


            reset = 1;
            io_input = 0;
            #20;
            reset = 0;
            #10;


            io_input = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: io_input = 1", test_num);


            reset = 1;
            io_input = 0;
            #20;
            reset = 0;
            #10;


            io_input = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Toggle io_input 1 -> 0", test_num);


            reset = 1;
            #20;
            reset = 0;
            #10;


            io_input = 1;
            #10;
            io_input = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Toggle io_input 0 -> 1", test_num);


            reset = 1;
            #20;
            reset = 0;
            #10;


            io_input = 0;
            #10;
            io_input = 1;
            #1;

            check_outputs(1'b0);
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
        input expected_io_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_result === (expected_io_result ^ io_result ^ expected_io_result)) begin
                $display("PASS");
                $display("  Outputs: io_result=%b",
                         io_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_result=%b",
                         expected_io_result);
                $display("  Got:      io_result=%b",
                         io_result);
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
