`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] di2;
    reg [4:0] rn1;
    reg [4:0] rn2;
    reg we2;
    wire [31:0] do1;
    wire [31:0] do2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .di2(di2),
        .rn1(rn1),
        .rn2(rn2),
        .we2(we2),
        .do1(do1),
        .do2(do2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        di2 = 0;
        rn1 = 0;
        rn2 = 0;
        we2 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Basic Write/Read Reg 7");

        rn2 = 7; di2 = 32'hA5A5A5A5; we2 = 1;
        @(posedge clk);
        #1;

        we2 = 0; rn1 = 7; rn2 = 7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5, 32'hA5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Boundary Check Reg 31");

        rn2 = 31; di2 = 32'h5555AAAA; we2 = 1;
        @(posedge clk);
        #1;

        we2 = 0; rn1 = 31; rn2 = 31;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h5555AAAA, 32'h5555AAAA);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Port 2 Bypass Check");

        rn2 = 15; di2 = 32'h1234ABCD; we2 = 1;
        #2;

        #1;


        check_outputs(do1, 32'h1234ABCD);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Dual Port Read Access");

        rn2 = 2; di2 = 32'h11111111; we2 = 1;
        @(posedge clk); #1;

        rn2 = 3; di2 = 32'h22222222; we2 = 1;
        @(posedge clk); #1;

        we2 = 0; rn1 = 2; rn2 = 3;
        @(posedge clk); #1;
        #1;

        check_outputs(32'h11111111, 32'h22222222);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Overwrite and Register 0 Check");

        rn2 = 0; di2 = 32'hCAFEBABE; we2 = 1;
        @(posedge clk); #1;

        rn2 = 0; di2 = 32'hDEADBEEF; we2 = 1;
        @(posedge clk); #1;

        we2 = 0; rn1 = 0; rn2 = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
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
        input [31:0] expected_do1;
        input [31:0] expected_do2;
        begin
            if (expected_do1 === (expected_do1 ^ do1 ^ expected_do1) &&
                expected_do2 === (expected_do2 ^ do2 ^ expected_do2)) begin
                $display("PASS");
                $display("  Outputs: do1=%h, do2=%h",
                         do1, do2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do1=%h, do2=%h",
                         expected_do1, expected_do2);
                $display("  Got:      do1=%h, do2=%h",
                         do1, do2);
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
        $dumpvars(0,clk, di2, rn1, rn2, we2, do1, do2);
    end

endmodule
