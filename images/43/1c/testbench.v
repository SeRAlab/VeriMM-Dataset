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
        CLOCKENABLE = 0;
        forever #5 CLOCKENABLE = ~CLOCKENABLE;
    end

        task reset_dut;

        begin
            DOUT0 = 0;
            DOUT1 = 0;
            INPUTCLK = 0;
            LATCHINPUTVALUE = 0;
            OUTPUTCLK = 0;
            OUTPUTENABLE = 0;

            repeat(2) @(posedge CLOCKENABLE);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            DOUT0 = 1; DOUT1 = 0;
            @(posedge CLOCKENABLE);
            #2;


            LATCHINPUTVALUE = 1;
            #5 INPUTCLK = 1; #5 INPUTCLK = 0;
            LATCHINPUTVALUE = 0;

            $display("Testcase %0d: Basic latch via INPUTCLK", test_num);
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            DOUT0 = 0; DOUT1 = 1;
            @(posedge CLOCKENABLE);
            #2;


            OUTPUTENABLE = 1;
            #5 OUTPUTCLK = 1; #5 OUTPUTCLK = 0;
            OUTPUTENABLE = 0;

            $display("Testcase %0d: Basic latch via OUTPUTCLK", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            DOUT0 = 1; DOUT1 = 1;
            @(posedge CLOCKENABLE); #2;
            LATCHINPUTVALUE = 1; #5 INPUTCLK = 1; #5 INPUTCLK = 0; LATCHINPUTVALUE = 0;


            DOUT0 = 0; DOUT1 = 0;
            @(posedge CLOCKENABLE); #2;
            LATCHINPUTVALUE = 0;
            #5 INPUTCLK = 1; #5 INPUTCLK = 0;

            $display("Testcase %0d: Verify LATCHINPUTVALUE gate (Output should remain 1,1)", test_num);
            #1;

            check_outputs(1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            DOUT0 = 0; DOUT1 = 1;
            @(posedge CLOCKENABLE); #2;
            OUTPUTENABLE = 1; #5 OUTPUTCLK = 1; #5 OUTPUTCLK = 0; OUTPUTENABLE = 0;


            DOUT0 = 1; DOUT1 = 1;
            @(posedge CLOCKENABLE); #2;
            OUTPUTENABLE = 0;
            #5 OUTPUTCLK = 1; #5 OUTPUTCLK = 0;

            $display("Testcase %0d: Verify OUTPUTENABLE gate (Output should remain 0,1)", test_num);
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            DOUT0 = 1; DOUT1 = 1;
            @(posedge CLOCKENABLE);


            #2 DOUT0 = 0; DOUT1 = 0;


            LATCHINPUTVALUE = 1;
            #5 INPUTCLK = 1; #5 INPUTCLK = 0;

            $display("Testcase %0d: Verify sampling logic captures data at CLOCKENABLE edge", test_num);
            #1;

            check_outputs(1, 1);
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
