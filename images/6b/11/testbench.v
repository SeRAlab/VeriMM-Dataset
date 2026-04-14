`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire pin1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pin1(pin1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            force dut.led_timer = 24'b0;
            @(posedge clk);
            #1;
            release dut.led_timer;
        end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcases1;

    reset_dut();

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
        testcases1();
        
        
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
        input expected_pin1;
        begin
            if (expected_pin1 === (expected_pin1 ^ pin1 ^ expected_pin1)) begin
                $display("PASS");
                $display("  Outputs: pin1=%b",
                         pin1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pin1=%b",
                         expected_pin1);
                $display("  Got:      pin1=%b",
                         pin1);
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
        $dumpvars(0,clk, pin1);
    end

endmodule
