`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [2:0] traffic_light;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .traffic_light(traffic_light)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        if ((cycle_count % 22) != 0) begin
            repeat (22 - (cycle_count % 22)) @(posedge clk);
        end
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Green light state (mid-duration)...", test_num);
        reset_dut();
        repeat(5) @(posedge clk);
        #1;
        #1;

        check_outputs(GREEN);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying transition to Yellow light...", test_num);
        reset_dut();
        repeat(11) @(posedge clk);
        #1;
        #1;

        check_outputs(YELLOW);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying transition to Red light...", test_num);
        reset_dut();
        repeat(13) @(posedge clk);
        #1;
        #1;

        check_outputs(RED);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying Red light at the end of duration (Cycle 22)...", test_num);
        reset_dut();
        repeat(22) @(posedge clk);
        #1;
        #1;

        check_outputs(RED);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verifying wrap-around back to Green (Cycle 23)...", test_num);
        reset_dut();
        repeat(23) @(posedge clk);
        #1;
        #1;

        check_outputs(GREEN);
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
        input [2:0] expected_traffic_light;
        begin
            if (expected_traffic_light === (expected_traffic_light ^ traffic_light ^ expected_traffic_light)) begin
                $display("PASS");
                $display("  Outputs: traffic_light=%h",
                         traffic_light);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: traffic_light=%h",
                         expected_traffic_light);
                $display("  Got:      traffic_light=%h",
                         traffic_light);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, traffic_light);
    end

endmodule
