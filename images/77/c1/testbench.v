`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] memdata;
    wire [31:0] memdatareg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .memdata(memdata),
        .memdatareg(memdatareg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        memdata = 32'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture All Zeros", test_num);
        reset_dut();
        memdata = 32'h00000000;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture All Ones", test_num);
        reset_dut();
        memdata = 32'hFFFFFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture Alternating Bits (0xAAAAAAAA)", test_num);
        reset_dut();
        memdata = 32'hAAAAAAAA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture Alternating Bits (0x55555555)", test_num);
        reset_dut();
        memdata = 32'h55555555;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture Pattern 0xDEADBEEF", test_num);
        reset_dut();
        memdata = 32'hDEADBEEF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Capture Pattern 0x12345678", test_num);
        reset_dut();
        memdata = 32'h12345678;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
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
        input [31:0] expected_memdatareg;
        begin
            if (expected_memdatareg === (expected_memdatareg ^ memdatareg ^ expected_memdatareg)) begin
                $display("PASS");
                $display("  Outputs: memdatareg=%h",
                         memdatareg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memdatareg=%h",
                         expected_memdatareg);
                $display("  Got:      memdatareg=%h",
                         memdatareg);
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
        $dumpvars(0,clk, memdata, memdatareg);
    end

endmodule
