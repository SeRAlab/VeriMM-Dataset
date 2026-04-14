`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg [7:0] Cmd;
    reg OutputEnable;
    reg Reset;
    wire AnalogPowerEnable;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .Cmd(Cmd),
        .OutputEnable(OutputEnable),
        .Reset(Reset),
        .AnalogPowerEnable(AnalogPowerEnable)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

    begin
        Reset = 1;
        Cmd = 0;
        OutputEnable = 0;
        @(posedge Clock);
        #2 Reset = 0;
        @(posedge Clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Power On Transition", test_num);
        reset_dut();

        OutputEnable = 1;
        Cmd = 80;
        @(posedge Clock);
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Block Power On if OE is 0", test_num);
        reset_dut();

        OutputEnable = 0;
        Cmd = 80;
        @(posedge Clock);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Power Off via Cmd 112", test_num);
        reset_dut();


        OutputEnable = 1;
        Cmd = 80;
        @(posedge Clock);
        #2;


        Cmd = 112;
        @(posedge Clock);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Power Off via OE Low", test_num);
        reset_dut();


        OutputEnable = 1;
        Cmd = 80;
        @(posedge Clock);
        #2;


        OutputEnable = 0;
        Cmd = 0;
        @(posedge Clock);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset behavior from ON state", test_num);
        reset_dut();


        OutputEnable = 1;
        Cmd = 80;
        @(posedge Clock);
        #2;


        Reset = 1;
        @(posedge Clock);
        #2 Reset = 0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maintain ON state for other commands", test_num);
        reset_dut();


        OutputEnable = 1;
        Cmd = 80;
        @(posedge Clock);
        #2;


        Cmd = 55;
        @(posedge Clock);
        #2;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maintain OFF state for other commands", test_num);
        reset_dut();

        OutputEnable = 1;
        Cmd = 79;
        @(posedge Clock);
        #2;

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
        testcase007();
        
        
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
        input expected_AnalogPowerEnable;
        begin
            if (expected_AnalogPowerEnable === (expected_AnalogPowerEnable ^ AnalogPowerEnable ^ expected_AnalogPowerEnable)) begin
                $display("PASS");
                $display("  Outputs: AnalogPowerEnable=%b",
                         AnalogPowerEnable);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AnalogPowerEnable=%b",
                         expected_AnalogPowerEnable);
                $display("  Got:      AnalogPowerEnable=%b",
                         AnalogPowerEnable);
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
        $dumpvars(0,Clock, Cmd, OutputEnable, Reset, AnalogPowerEnable);
    end

endmodule
