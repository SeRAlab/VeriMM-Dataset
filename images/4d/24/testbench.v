`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg inp;
    reg rst;
    wire [31:0] outp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inp(inp),
        .rst(rst),
        .outp(outp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            inp = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Initial IDLE check");
            reset_dut();

            #1;


            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Transition to ACTIVE (1 cycle check)");
            reset_dut();
            inp = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Count increment in ACTIVE");
            reset_dut();
            inp = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(32'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Return to IDLE from ACTIVE");
            reset_dut();
            inp = 1;
            repeat(3) @(posedge clk);
            inp = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Assert reset while in ACTIVE");
            reset_dut();
            inp = 1;
            repeat(4) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Input high for one edge only");
            reset_dut();
            inp = 1;
            @(posedge clk);
            inp = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'd0);
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
        input [31:0] expected_outp;
        begin
            if (expected_outp === (expected_outp ^ outp ^ expected_outp)) begin
                $display("PASS");
                $display("  Outputs: outp=%h",
                         outp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outp=%h",
                         expected_outp);
                $display("  Got:      outp=%h",
                         outp);
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
        $dumpvars(0,clk, inp, rst, outp);
    end

endmodule
