`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg proximity_signal;
    wire proximity_event;
    wire [7:0] proximity_position;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .proximity_signal(proximity_signal),
        .proximity_event(proximity_event),
        .proximity_position(proximity_position)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            proximity_signal = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Idle State Check", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %02d: Proximity Detection Check", test_num);
            reset_dut();
            proximity_signal = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Proximity Release Check", test_num);
            reset_dut();


            proximity_signal = 1;
            @(posedge clk);
            #1;


            proximity_signal = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Sustained Proximity Check", test_num);
            reset_dut();

            proximity_signal = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Rapid Toggle Check", test_num);
            reset_dut();

            proximity_signal = 1;
            @(posedge clk);
            proximity_signal = 0;
            @(posedge clk);
            proximity_signal = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 8'h00);
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
        input expected_proximity_event;
        input [7:0] expected_proximity_position;
        begin
            if (expected_proximity_event === (expected_proximity_event ^ proximity_event ^ expected_proximity_event) &&
                expected_proximity_position === (expected_proximity_position ^ proximity_position ^ expected_proximity_position)) begin
                $display("PASS");
                $display("  Outputs: proximity_event=%b, proximity_position=%h",
                         proximity_event, proximity_position);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: proximity_event=%b, proximity_position=%h",
                         expected_proximity_event, expected_proximity_position);
                $display("  Got:      proximity_event=%b, proximity_position=%h",
                         proximity_event, proximity_position);
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
        $dumpvars(0,clk, proximity_signal, proximity_event, proximity_position);
    end

endmodule
