`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] branch_addr;
    reg branch_enable;
    reg clk;
    reg rst;
    reg [5:0] stall;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_addr(branch_addr),
        .branch_enable(branch_enable),
        .clk(clk),
        .rst(rst),
        .stall(stall),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall = 0;
            branch_enable = 0;
            branch_addr = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Behavior", test_num);
            reset_dut();
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Increment (PC+4)", test_num);
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Branching", test_num);
            reset_dut();
            branch_enable = 1;
            branch_addr = 32'hAAAA_BBBB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stall during Increment", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            stall = 6'b000001;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Stall Priority over Branch", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            stall = 6'b000001;
            branch_enable = 1;
            branch_addr = 32'h1234_5678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Stall bit [0] vs other bits", test_num);
            reset_dut();
            stall = 6'b111110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0004);
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
        input [31:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,branch_addr, branch_enable, clk, rst, stall, pc);
    end

endmodule
