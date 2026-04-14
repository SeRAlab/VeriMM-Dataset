`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] In;
    reg InEnable;
    reg clock;
    reg reset;
    wire [15:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In(In),
        .InEnable(InEnable),
        .clock(clock),
        .reset(reset),
        .Out(Out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        In = 16'h0000;
        InEnable = 0;
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify Reset State", test_num);
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Normal Write Operation", test_num);
        reset_dut();
        In = 16'hABCD;
        InEnable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data Retention (InEnable=0)", test_num);
        reset_dut();

        In = 16'h1234;
        InEnable = 1;
        @(posedge clock);
        #1;

        In = 16'h5678;
        InEnable = 0;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority over InEnable", test_num);
        reset_dut();

        In = 16'hFFFF;
        InEnable = 1;
        reset = 1;
        @(posedge clock);
        #1;
        reset = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All-Ones Input", test_num);
        reset_dut();
        In = 16'hFFFF;
        InEnable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Continuous Multi-cycle Updates", test_num);
        reset_dut();
        In = 16'h1111; InEnable = 1;
        @(posedge clock);
        #1;
        In = 16'h2222; InEnable = 1;
        @(posedge clock);
        #1;
        In = 16'h3333; InEnable = 1;
        @(posedge clock);
        #1;
        #1;

        check_outputs(16'h3333);
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
        input [15:0] expected_Out;
        begin
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
        $dumpvars(0,In, InEnable, clock, reset, Out);
    end

endmodule
