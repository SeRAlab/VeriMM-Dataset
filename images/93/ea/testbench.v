`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk50;
    wire [7:0] LEDS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50(clk50),
        .LEDS(LEDS)
    );

    // Clock generation (10ns period)
    initial begin
        clk50 = 0;
        forever #5 clk50 = ~clk50;
    end

        task reset_dut;

        begin
            force dut.counter = 32'h0;
            @(posedge clk50);
            release dut.counter;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying reset state (LEDS should be 00)", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying transition to LEDS = 01", test_num);
            reset_dut();

            force dut.counter = 32'h00FFFFFF;
            @(posedge clk50);
            release dut.counter;
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying transition to LEDS = 80", test_num);
            reset_dut();

            force dut.counter = 32'h7FFFFFFF;
            @(posedge clk50);
            release dut.counter;
            #1;

            #1;


            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying LEDS = FF at max counter value", test_num);
            reset_dut();

            force dut.counter = 32'hFF000000;
            repeat(5) @(posedge clk50);
            #1;

            #1;


            check_outputs(8'hFF);
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
        input [7:0] expected_LEDS;
        begin
            if (expected_LEDS === (expected_LEDS ^ LEDS ^ expected_LEDS)) begin
                $display("PASS");
                $display("  Outputs: LEDS=%h",
                         LEDS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDS=%h",
                         expected_LEDS);
                $display("  Got:      LEDS=%h",
                         LEDS);
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
        $dumpvars(0,clk50, LEDS);
    end

endmodule
