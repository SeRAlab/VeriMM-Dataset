`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ref_in;
    reg sensor_in;
    wire touched_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ref_in(ref_in),
        .sensor_in(sensor_in),
        .touched_out(touched_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Both signals low - No touch expected", test_num);
        sensor_in = 0;
        ref_in = 0;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Sensor high, Reference low - Touch expected", test_num);
        sensor_in = 1;
        ref_in = 0;
        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Sensor low, Reference high - No touch expected", test_num);
        sensor_in = 0;
        ref_in = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Both signals high - No touch expected (Baseline Offset)", test_num);
        sensor_in = 1;
        ref_in = 1;
        #10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Transition from no-touch to touch", test_num);
        sensor_in = 0;
        ref_in = 0;
        #5;
        sensor_in = 1;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Transition from touch back to no-touch", test_num);
        sensor_in = 1;
        ref_in = 0;
        #5;
        sensor_in = 0;
        #10;
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
        testcase005();
        testcase006();
        
        
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
        input expected_touched_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_touched_out === (expected_touched_out ^ touched_out ^ expected_touched_out)) begin
                $display("PASS");
                $display("  Outputs: touched_out=%b",
                         touched_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: touched_out=%b",
                         expected_touched_out);
                $display("  Got:      touched_out=%b",
                         touched_out);
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
