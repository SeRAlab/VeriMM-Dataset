`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce_n;
    reg ce_p;
    reg clk_neg;
    reg clk_pos;
    reg [7:0] cpu_din;
    reg nINT;
    reg reset;
    wire [15:0] cpu_addr;
    wire [7:0] cpu_dout;
    wire nIORQ;
    wire nM1;
    wire nMREQ;
    wire nRD;
    wire nRFSH;
    wire nWR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce_n(ce_n),
        .ce_p(ce_p),
        .clk_neg(clk_neg),
        .clk_pos(clk_pos),
        .cpu_din(cpu_din),
        .nINT(nINT),
        .reset(reset),
        .cpu_addr(cpu_addr),
        .cpu_dout(cpu_dout),
        .nIORQ(nIORQ),
        .nM1(nM1),
        .nMREQ(nMREQ),
        .nRD(nRD),
        .nRFSH(nRFSH),
        .nWR(nWR)
    );

    // Clock generation (10ns period)
    initial begin
        clk_neg = 0;
        forever #5 clk_neg = ~clk_neg;
    end

        task reset_dut;

        begin
            reset = 1;
            ce_n = 0;
            ce_p = 1;
            cpu_din = 8'h00;
            nINT = 1;
            repeat(2) @(posedge clk_neg);
            #2 reset = 0;
            @(posedge clk_neg);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Post-Reset Initial State", test_num);
            reset_dut();


            #1;



            check_outputs(16'h0000, 8'h00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Fetch Cycle (M1) Detection", test_num);
            reset_dut();

            repeat(1) @(posedge clk_neg);
            #2;

            #1;


            check_outputs(16'h0000, 8'h00, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Refresh Cycle Detection", test_num);
            reset_dut();

            repeat(3) @(posedge clk_neg);
            #2;


            #1;



            check_outputs(cpu_addr, 8'h00, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Chip Enable Disable", test_num);
            reset_dut();
            ce_n = 1;
            ce_p = 0;
            repeat(2) @(posedge clk_neg);
            #2;

            #1;


            check_outputs(cpu_addr, 8'h00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Interrupt Response Check", test_num);
            reset_dut();
            nINT = 0;
            repeat(5) @(posedge clk_neg);
            #2;

            #1;


            check_outputs(cpu_addr, cpu_dout, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input [15:0] expected_cpu_addr;
        input [7:0] expected_cpu_dout;
        input expected_nIORQ;
        input expected_nM1;
        input expected_nMREQ;
        input expected_nRD;
        input expected_nRFSH;
        input expected_nWR;
        begin
            if (expected_cpu_addr === (expected_cpu_addr ^ cpu_addr ^ expected_cpu_addr) &&
                expected_cpu_dout === (expected_cpu_dout ^ cpu_dout ^ expected_cpu_dout) &&
                expected_nIORQ === (expected_nIORQ ^ nIORQ ^ expected_nIORQ) &&
                expected_nM1 === (expected_nM1 ^ nM1 ^ expected_nM1) &&
                expected_nMREQ === (expected_nMREQ ^ nMREQ ^ expected_nMREQ) &&
                expected_nRD === (expected_nRD ^ nRD ^ expected_nRD) &&
                expected_nRFSH === (expected_nRFSH ^ nRFSH ^ expected_nRFSH) &&
                expected_nWR === (expected_nWR ^ nWR ^ expected_nWR)) begin
                $display("PASS");
                $display("  Outputs: cpu_addr=%h, cpu_dout=%h, nIORQ=%b, nM1=%b, nMREQ=%b, nRD=%b, nRFSH=%b, nWR=%b",
                         cpu_addr, cpu_dout, nIORQ, nM1, nMREQ, nRD, nRFSH, nWR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpu_addr=%h, cpu_dout=%h, nIORQ=%b, nM1=%b, nMREQ=%b, nRD=%b, nRFSH=%b, nWR=%b",
                         expected_cpu_addr, expected_cpu_dout, expected_nIORQ, expected_nM1, expected_nMREQ, expected_nRD, expected_nRFSH, expected_nWR);
                $display("  Got:      cpu_addr=%h, cpu_dout=%h, nIORQ=%b, nM1=%b, nMREQ=%b, nRD=%b, nRFSH=%b, nWR=%b",
                         cpu_addr, cpu_dout, nIORQ, nM1, nMREQ, nRD, nRFSH, nWR);
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
        $dumpvars(0,ce_n, ce_p, clk_neg, clk_pos, cpu_din, nINT, reset, cpu_addr, cpu_dout, nIORQ, nM1, nMREQ, nRD, nRFSH, nWR);
    end

endmodule
