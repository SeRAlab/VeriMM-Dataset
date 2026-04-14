`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_num;
    wire [15:0] rounded_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_num(input_num),
        .rounded_num(rounded_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        input_num = 16'h0000;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x0001 (Exact power of 2)", test_num);
        input_num = 16'h0001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x0003 (Midpoint 2-4 rounds up)", test_num);
        input_num = 16'h0003;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x0005 (Closer to 4)", test_num);
        input_num = 16'h0005;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x000C (Midpoint 8-16 rounds to 16)", test_num);
        input_num = 16'h000C;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0xAB18 (MSB check, LSB 24 rounds to 32)", test_num);
        input_num = 16'hAB18;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hAB20);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x5560 (Midpoint 64-128 rounds to 128)", test_num);
        input_num = 16'h5560;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h5580);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0xFFFF (Max byte rounds to 128)", test_num);
        input_num = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFF80);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Input 0x002F (Value 47 rounds to 32)", test_num);
        input_num = 16'h002F;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0020);
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
        testcase008();
        
        
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
        input [15:0] expected_rounded_num;
        begin
            if (expected_rounded_num === (expected_rounded_num ^ rounded_num ^ expected_rounded_num)) begin
                $display("PASS");
                $display("  Outputs: rounded_num=%h",
                         rounded_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rounded_num=%h",
                         expected_rounded_num);
                $display("  Got:      rounded_num=%h",
                         rounded_num);
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
        $dumpvars(0,clk, input_num, rounded_num);
    end

endmodule
