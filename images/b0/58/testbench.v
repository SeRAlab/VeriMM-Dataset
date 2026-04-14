`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCKENABLE;
    reg DOUT0;
    reg DOUT1;
    reg INPUTCLK;
    reg LATCHINPUTVALUE;
    reg OUTPUTCLK;
    reg OUTPUTENABLE;
    wire DIN0;
    wire DIN1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCKENABLE(CLOCKENABLE),
        .DOUT0(DOUT0),
        .DOUT1(DOUT1),
        .INPUTCLK(INPUTCLK),
        .LATCHINPUTVALUE(LATCHINPUTVALUE),
        .OUTPUTCLK(OUTPUTCLK),
        .OUTPUTENABLE(OUTPUTENABLE),
        .DIN0(DIN0),
        .DIN1(DIN1)
    );

    // Clock generation (10ns period)
    initial begin
        INPUTCLK = 0;
        forever #5 INPUTCLK = ~INPUTCLK;
    end

        task reset_dut;

        begin
            CLOCKENABLE = 0;
            DOUT0 = 0;
            DOUT1 = 0;
            LATCHINPUTVALUE = 0;
            OUTPUTENABLE = 0;
            drive_pin = 0;
            PACKAGEPIN_driver = 0;
            repeat(2) @(posedge INPUTCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            drive_pin = 1;
            PACKAGEPIN_driver = 1;
            CLOCKENABLE = 1;
            LATCHINPUTVALUE = 0;
            repeat(2) @(posedge INPUTCLK);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            drive_pin = 1;
            PACKAGEPIN_driver = 0;
            CLOCKENABLE = 1;
            LATCHINPUTVALUE = 0;
            repeat(2) @(posedge INPUTCLK);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            drive_pin = 1;
            PACKAGEPIN_driver = 0;
            CLOCKENABLE = 1;
            repeat(2) @(posedge INPUTCLK);


            CLOCKENABLE = 0;
            PACKAGEPIN_driver = 1;
            repeat(2) @(posedge INPUTCLK);


            #1;



            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            drive_pin = 0;
            OUTPUTENABLE = 1;
            CLOCKENABLE = 1;
            DOUT0 = 1;
            DOUT1 = 1;
            repeat(2) @(posedge OUTPUTCLK);
            repeat(2) @(posedge INPUTCLK);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            OUTPUTENABLE = 0;
            DOUT0 = 1;
            DOUT1 = 1;

            drive_pin = 1;
            PACKAGEPIN_driver = 0;
            CLOCKENABLE = 1;
            repeat(2) @(posedge INPUTCLK);

            #1;


            check_outputs(1'b0, 1'b0);
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
        input expected_DIN0;
        input expected_DIN1;
        begin
            if (expected_DIN0 === (expected_DIN0 ^ DIN0 ^ expected_DIN0) &&
                expected_DIN1 === (expected_DIN1 ^ DIN1 ^ expected_DIN1)) begin
                $display("PASS");
                $display("  Outputs: DIN0=%b, DIN1=%b",
                         DIN0, DIN1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DIN0=%b, DIN1=%b",
                         expected_DIN0, expected_DIN1);
                $display("  Got:      DIN0=%b, DIN1=%b",
                         DIN0, DIN1);
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
        $dumpvars(0,CLOCKENABLE, DOUT0, DOUT1, INPUTCLK, LATCHINPUTVALUE, OUTPUTCLK, OUTPUTENABLE, DIN0, DIN1);
    end

endmodule
