`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clk;
    reg [31:0] din;
    reg wen;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .wen(wen),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            addr = 32'h0;
            din = 32'hDEADBEEF;
            wen = 1;
            @(posedge clk);
            #1;

            wen = 0;
            @(posedge clk);
            #1;
            $display("Test Case 001: Basic Write/Read Address 0");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            addr = 32'd1023;
            din = 32'h12345678;
            wen = 1;
            @(posedge clk);
            #1;

            wen = 0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Boundary Address 1023");
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            addr = 32'd500;
            din = 32'hAAAA_AAAA;
            wen = 1;
            @(posedge clk);
            #1;

            din = 32'h5555_5555;
            @(posedge clk);
            #1;

            wen = 0;
            @(posedge clk);
            #1;
            $display("Test Case 003: Overwrite existing data at Address 500");
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            addr = 32'd10;
            din = 32'hCAFE_BABE;
            wen = 1;
            @(posedge clk);
            #1;

            din = 32'h0000_0000;
            wen = 0;
            @(posedge clk);
            #1;

            $display("Test Case 004: Write Enable check (wen=0 should prevent writing)");
            #1;

            check_outputs(32'hCAFE_BABE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            addr = 32'd1; din = 32'h1; wen = 1;
            @(posedge clk); #1;

            addr = 32'd2; din = 32'h2; wen = 1;
            @(posedge clk); #1;

            addr = 32'd1; wen = 0;
            @(posedge clk); #1;
            $display("Test Case 005: Consecutive Writes - Checking Address 1");
            #1;

            check_outputs(32'h1);
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, wen, dout);
    end

endmodule
