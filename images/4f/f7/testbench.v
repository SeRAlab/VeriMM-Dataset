`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [9:0] OutputCLKFreq;
    reg RESET;
    reg [9:0] SystemCLKFreq;
    wire OutputCLK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .OutputCLKFreq(OutputCLKFreq),
        .RESET(RESET),
        .SystemCLKFreq(SystemCLKFreq),
        .OutputCLK(OutputCLK)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            SystemCLKFreq = 10'd0;
            OutputCLKFreq = 10'd0;
            repeat(2) @(posedge CLK);
            #2 RESET = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 2 (100/50), check after 2 cycles", test_num);
            SystemCLKFreq = 10'd100;
            OutputCLKFreq = 10'd50;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 4 (100/25), check after 2 cycles", test_num);
            SystemCLKFreq = 10'd100;
            OutputCLKFreq = 10'd25;
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 4 (100/25), check after 4 cycles", test_num);
            SystemCLKFreq = 10'd100;
            OutputCLKFreq = 10'd25;
            repeat(4) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 10 (500/50), check after 5 cycles", test_num);
            SystemCLKFreq = 10'd500;
            OutputCLKFreq = 10'd50;
            repeat(5) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 10 (500/50), check after 10 cycles", test_num);
            SystemCLKFreq = 10'd500;
            OutputCLKFreq = 10'd50;
            repeat(10) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Ratio 20 (400/20), check after 10 cycles", test_num);
            SystemCLKFreq = 10'd400;
            OutputCLKFreq = 10'd20;
            repeat(10) @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_OutputCLK;
        begin
            if (expected_OutputCLK === (expected_OutputCLK ^ OutputCLK ^ expected_OutputCLK)) begin
                $display("PASS");
                $display("  Outputs: OutputCLK=%b",
                         OutputCLK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OutputCLK=%b",
                         expected_OutputCLK);
                $display("  Got:      OutputCLK=%b",
                         OutputCLK);
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
        $dumpvars(0,CLK, OutputCLKFreq, RESET, SystemCLKFreq, OutputCLK);
    end

endmodule
