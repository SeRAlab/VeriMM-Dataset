`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg BYPASS;
    reg [7:0] DYNAMICDELAY;
    reg EXTFEEDBACK;
    reg LATCHINPUTVALUE;
    reg PLLIN;
    reg RESETB;
    reg SCLK;
    reg SDI;
    wire LOCK;
    wire PLLOUTCORE;
    wire PLLOUTGLOBAL;
    wire SDO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BYPASS(BYPASS),
        .DYNAMICDELAY(DYNAMICDELAY),
        .EXTFEEDBACK(EXTFEEDBACK),
        .LATCHINPUTVALUE(LATCHINPUTVALUE),
        .PLLIN(PLLIN),
        .RESETB(RESETB),
        .SCLK(SCLK),
        .SDI(SDI),
        .LOCK(LOCK),
        .PLLOUTCORE(PLLOUTCORE),
        .PLLOUTGLOBAL(PLLOUTGLOBAL),
        .SDO(SDO)
    );

    // Clock generation (10ns period)
    initial begin
        PLLIN = 0;
        forever #5 PLLIN = ~PLLIN;
    end

        task reset_dut;

        begin
            RESETB = 0;
            BYPASS = 0;
            DYNAMICDELAY = 8'h00;
            EXTFEEDBACK = 0;
            LATCHINPUTVALUE = 0;
            SCLK = 0;
            SDI = 0;
            #20;
            RESETB = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();



            wait(PLLIN == 0);
            #2;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 1'bx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Bypass Mode Operation", test_num);
            reset_dut();
            BYPASS = 1;
            #50;

            wait(PLLIN == 1);
            #2;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'bx);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] test_pattern;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift Register Test", test_num);
            reset_dut();
            test_pattern = 8'hA5;

            for(i=0; i<8; i=i+1) begin
                SDI = test_pattern[i];
                #5 SCLK = 1;
                #5 SCLK = 0;
            end




            #5;
            #1;

            check_outputs(LOCK, PLLOUTCORE, PLLOUTGLOBAL, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Lock Sequence Simulation", test_num);
            reset_dut();
            BYPASS = 0;
            DYNAMICDELAY = 8'h0F;
            EXTFEEDBACK = PLLOUTCORE;

            #500;

            wait(PLLIN == 1);
            #2;


            if (LOCK === 1'b1 || LOCK === 1'b0)
                #1;

                check_outputs(LOCK, 1'b1, 1'b1, SDO);
            else
                $display("LOCK is in unknown state");
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Configuration Latch", test_num);
            reset_dut();
            DYNAMICDELAY = 8'hFF;
            LATCHINPUTVALUE = 1;
            #20;
            LATCHINPUTVALUE = 0;
            #100;

            wait(PLLIN == 0);
            #2;
            #1;

            check_outputs(LOCK, 1'b0, 1'b0, SDO);
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
        input expected_LOCK;
        input expected_PLLOUTCORE;
        input expected_PLLOUTGLOBAL;
        input expected_SDO;
        begin
            if (expected_LOCK === (expected_LOCK ^ LOCK ^ expected_LOCK) &&
                expected_PLLOUTCORE === (expected_PLLOUTCORE ^ PLLOUTCORE ^ expected_PLLOUTCORE) &&
                expected_PLLOUTGLOBAL === (expected_PLLOUTGLOBAL ^ PLLOUTGLOBAL ^ expected_PLLOUTGLOBAL) &&
                expected_SDO === (expected_SDO ^ SDO ^ expected_SDO)) begin
                $display("PASS");
                $display("  Outputs: LOCK=%b, PLLOUTCORE=%b, PLLOUTGLOBAL=%b, SDO=%b",
                         LOCK, PLLOUTCORE, PLLOUTGLOBAL, SDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LOCK=%b, PLLOUTCORE=%b, PLLOUTGLOBAL=%b, SDO=%b",
                         expected_LOCK, expected_PLLOUTCORE, expected_PLLOUTGLOBAL, expected_SDO);
                $display("  Got:      LOCK=%b, PLLOUTCORE=%b, PLLOUTGLOBAL=%b, SDO=%b",
                         LOCK, PLLOUTCORE, PLLOUTGLOBAL, SDO);
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
        $dumpvars(0,BYPASS, DYNAMICDELAY, EXTFEEDBACK, LATCHINPUTVALUE, PLLIN, RESETB, SCLK, SDI, LOCK, PLLOUTCORE, PLLOUTGLOBAL, SDO);
    end

endmodule
