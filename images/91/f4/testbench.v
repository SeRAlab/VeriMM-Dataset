`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instr;
    reg reset;
    wire [1:0] func;
    wire [2:0] rdst;
    wire [2:0] rsrc;
    wire status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .instr(instr),
        .reset(reset),
        .func(func),
        .rdst(rdst),
        .rsrc(rsrc),
        .status(status)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instr = 8'h00;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset = 1;
            instr = 8'hFF;
            @(posedge clk);
            #1;
            reset = 0;

            #1;


            check_outputs(2'b00, 3'b000, 3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Instruction Capture (8'hB3)", test_num);
            reset_dut();
            instr = 8'b10_110_011;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b10, 3'b110, 3'b011, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: All Ones Instruction (8'hFF)", test_num);
            reset_dut();
            instr = 8'b11_111_111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b11, 3'b111, 3'b111, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All Zeros Instruction (8'h00)", test_num);
            reset_dut();
            instr = 8'b00_000_000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b00, 3'b000, 3'b000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Alternating Bits Instruction (8'h55)", test_num);
            reset_dut();
            instr = 8'b01_010_101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(2'b01, 3'b010, 3'b101, 1'b1);
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
        input [1:0] expected_func;
        input [2:0] expected_rdst;
        input [2:0] expected_rsrc;
        input expected_status;
        begin
            if (expected_func === (expected_func ^ func ^ expected_func) &&
                expected_rdst === (expected_rdst ^ rdst ^ expected_rdst) &&
                expected_rsrc === (expected_rsrc ^ rsrc ^ expected_rsrc) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: func=%h, rdst=%h, rsrc=%h, status=%b",
                         func, rdst, rsrc, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: func=%h, rdst=%h, rsrc=%h, status=%b",
                         expected_func, expected_rdst, expected_rsrc, expected_status);
                $display("  Got:      func=%h, rdst=%h, rsrc=%h, status=%b",
                         func, rdst, rsrc, status);
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
        $dumpvars(0,clk, instr, reset, func, rdst, rsrc, status);
    end

endmodule
