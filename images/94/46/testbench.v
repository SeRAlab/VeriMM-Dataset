`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addr;
    reg clk;
    reg [15:0] d;
    reg load;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .d(d),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr <= 0;
        d <= 0;
        load <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write and Read", test_num);


        addr = 12'h001; d = 16'hAAAA; load = 1;
        @(posedge clk); #1;


        load = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Max Address Boundary", test_num);


        addr = 12'hFFF; d = 16'h5555; load = 1;
        @(posedge clk); #1;

        load = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Verify Load=0 prevents write", test_num);


        addr = 12'h010; d = 16'h1234; load = 1;
        @(posedge clk); #1;


        addr = 12'h010; d = 16'h9999; load = 0;
        @(posedge clk); #1;


        @(posedge clk); #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Multiple address persistence", test_num);


        addr = 12'h0A0; d = 16'hA0A0; load = 1;
        @(posedge clk); #1;


        addr = 12'h0B0; d = 16'hB0B0; load = 1;
        @(posedge clk); #1;


        load = 0; addr = 12'h0A0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'hA0A0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Overwriting data", test_num);


        addr = 12'h100; d = 16'h1111; load = 1;
        @(posedge clk); #1;


        addr = 12'h100; d = 16'h2222; load = 1;
        @(posedge clk); #1;


        load = 0;
        @(posedge clk); #1;
        #1;

        check_outputs(16'h2222);
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
        input [15:0] expected_q;
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
        $dumpvars(0,addr, clk, d, load, q);
    end

endmodule
