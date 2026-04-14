`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clrn;
    reg [31:0] d;
    reg ena;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clrn(clrn),
        .d(d),
        .ena(ena),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clrn = 1;
        ena = 0;
        d = 32'h0;
        #12;
        clrn = 0;
        #5;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Checking Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Basic Load (ena=1)", test_num);
        reset_dut();
        ena = 1;
        d = 32'hDEADBEEF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Enable Low (Holding value)", test_num);
        reset_dut();

        ena = 1;
        d = 32'hAAAA5555;
        @(posedge clk);
        #2;

        ena = 0;
        d = 32'hFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Asynchronous Clear Mid-cycle", test_num);
        reset_dut();
        ena = 1;
        d = 32'h12345678;
        @(posedge clk);
        #2;

        #3;
        clrn = 1;
        #1;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Testing all bits high", test_num);
        reset_dut();
        ena = 1;
        d = 32'hFFFFFFFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Sequential updates", test_num);
        reset_dut();
        ena = 1;
        d = 32'h1; @(posedge clk);
        d = 32'h2; @(posedge clk);
        d = 32'h3; @(posedge clk);
        #2;
        #1;

        check_outputs(32'h3);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, clrn, d, ena, q);
    end

endmodule
