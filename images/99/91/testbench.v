`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [29:0] addr;
    reg clk;
    reg rst;
    wire [31:0] inst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rst(rst),
        .inst(inst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            addr = 30'h0;
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
            $display("Test Case 001: Reset behavior...");

            addr = 30'hA5A5A5A5;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Undefined high address (default to zero)...");
            reset_dut();
            addr = 30'h3FFFFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Arbitrary undefined address...");
            reset_dut();
            addr = 30'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Synchronous timing check...");
            reset_dut();
            addr = 30'd10;

            #2;
            if (inst !== 32'h00000000) begin
                $display("Warning: Output changed before clock edge (expected synchronous)");
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Reset during active address...");
            reset_dut();
            addr = 30'd20;
            @(posedge clk);
            #1;
            rst = 1;
            @(posedge clk);
            #1;
            rst = 0;

            #1;


            check_outputs(32'h00000000);
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
        input [31:0] expected_inst;
        begin
            if (expected_inst === (expected_inst ^ inst ^ expected_inst)) begin
                $display("PASS");
                $display("  Outputs: inst=%h",
                         inst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inst=%h",
                         expected_inst);
                $display("  Got:      inst=%h",
                         inst);
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
        $dumpvars(0,addr, clk, rst, inst);
    end

endmodule
