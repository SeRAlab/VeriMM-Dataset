`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK_50;
    wire [7:0] LEDG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK_50(CLOCK_50),
        .LEDG(LEDG)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK_50 = 0;
        forever #5 CLOCK_50 = ~CLOCK_50;
    end

        task reset_dut;

        begin
            $display("\nResetting circuit...");
            force dut.counter = 32'h0;
            @(posedge CLOCK_50);
            #1;
            release dut.counter;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking initial state", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking MSB increment (00 -> 01)", test_num);
            reset_dut();
            force dut.counter = 32'h00FF_FFFF;
            @(posedge CLOCK_50);
            #1;
            release dut.counter;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking mid-range transition (7F -> 80)", test_num);
            reset_dut();
            force dut.counter = 32'h7FFF_FFFF;
            @(posedge CLOCK_50);
            #1;
            release dut.counter;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking overflow wrap-around (FF -> 00)", test_num);
            reset_dut();
            force dut.counter = 32'hFFFF_FFFF;
            @(posedge CLOCK_50);
            #1;
            release dut.counter;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking rapid high-order increments", test_num);
            reset_dut();


            force dut.counter = 32'hAAFF_FFFF;
            @(posedge CLOCK_50);
            #1;
            release dut.counter;
            #1;

            check_outputs(8'hAB);
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
        input [7:0] expected_LEDG;
        begin
            if (expected_LEDG === (expected_LEDG ^ LEDG ^ expected_LEDG)) begin
                $display("PASS");
                $display("  Outputs: LEDG=%h",
                         LEDG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDG=%h",
                         expected_LEDG);
                $display("  Got:      LEDG=%h",
                         LEDG);
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
        $dumpvars(0,CLOCK_50, LEDG);
    end

endmodule
