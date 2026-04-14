`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg clk;
    reg [31:0] idat;
    wire [31:0] odat;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .clk(clk),
        .idat(idat),
        .odat(odat)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            RegWrite = 0;
            idat = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write Operation");
            test_num = 1;
            reset_dut();

            RegWrite = 1;
            idat = 32'hDEADBEEF;

            @(negedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: RegWrite Disable Check");
            test_num = 2;
            reset_dut();


            RegWrite = 1;
            idat = 32'h11111111;
            @(negedge clk); @(posedge clk); #1;


            RegWrite = 0;
            idat = 32'hFFFFFFFF;
            @(negedge clk); @(posedge clk); #2;


            #1;



            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Consecutive Writes");
            test_num = 3;
            reset_dut();

            RegWrite = 1;
            idat = 32'hAAAA5555;
            @(negedge clk); @(posedge clk); #1;

            idat = 32'h5555AAAA;
            @(negedge clk); @(posedge clk); #2;

            #1;


            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All Zeros and All Ones");
            test_num = 4;
            reset_dut();


            RegWrite = 1;
            idat = 32'h00000000;
            @(negedge clk); @(posedge clk); #1;


            idat = 32'hFFFFFFFF;
            @(negedge clk); @(posedge clk); #2;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Stability post-capture");
            test_num = 5;
            reset_dut();

            RegWrite = 1;
            idat = 32'h12345678;
            @(negedge clk);
            #2;
            idat = 32'h0;
            @(posedge clk);
            #2;

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
        input [31:0] expected_odat;
        begin
            if (expected_odat === (expected_odat ^ odat ^ expected_odat)) begin
                $display("PASS");
                $display("  Outputs: odat=%h",
                         odat);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: odat=%h",
                         expected_odat);
                $display("  Got:      odat=%h",
                         odat);
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
        $dumpvars(0,RegWrite, clk, idat, odat);
    end

endmodule
