`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg io_input_ctr_done;
    wire io_output_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_input_ctr_done(io_input_ctr_done),
        .io_output_done(io_output_done)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Verify Logic Low Pass-through", test_num);
            io_input_ctr_done = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Verify Logic High Pass-through", test_num);
            io_input_ctr_done = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Verify Response to Signal Transition (0 to 1)", test_num);
            io_input_ctr_done = 1'b0;
            #10;
            io_input_ctr_done = 1'b1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Verify Response to Signal Transition (1 to 0)", test_num);
            io_input_ctr_done = 1'b1;
            #10;
            io_input_ctr_done = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Verify Rapid Toggling", test_num);
            io_input_ctr_done = 1'b0;
            #5; io_input_ctr_done = 1'b1;
            #5; io_input_ctr_done = 1'b0;
            #5; io_input_ctr_done = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_io_output_done;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_output_done === (expected_io_output_done ^ io_output_done ^ expected_io_output_done)) begin
                $display("PASS");
                $display("  Outputs: io_output_done=%b",
                         io_output_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output_done=%b",
                         expected_io_output_done);
                $display("  Got:      io_output_done=%b",
                         io_output_done);
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
