`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] aluresult;
    reg branch;
    reg clk;
    reg [15:0] data_to_mem;
    reg memread;
    reg memtoreg;
    reg memwrite;
    reg [3:0] regdst;
    reg regwrite;
    reg zero;
    wire [15:0] aluresultout;
    wire branchout;
    wire [15:0] data_to_memout;
    wire memreadout;
    wire memtoregout;
    wire memwriteout;
    wire [3:0] regdstout;
    wire regwriteout;
    wire zeroout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aluresult(aluresult),
        .branch(branch),
        .clk(clk),
        .data_to_mem(data_to_mem),
        .memread(memread),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .regdst(regdst),
        .regwrite(regwrite),
        .zero(zero),
        .aluresultout(aluresultout),
        .branchout(branchout),
        .data_to_memout(data_to_memout),
        .memreadout(memreadout),
        .memtoregout(memtoregout),
        .memwriteout(memwriteout),
        .regdstout(regdstout),
        .regwriteout(regwriteout),
        .zeroout(zeroout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            aluresult = 0;
            branch = 0;
            data_to_mem = 0;
            memread = 0;
            memtoreg = 0;
            memwrite = 0;
            regdst = 0;
            regwrite = 0;
            zero = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            aluresult = 16'h1234;
            branch = 1;
            data_to_mem = 16'hABCD;
            memread = 0;
            memtoreg = 1;
            memwrite = 1;
            regdst = 4'hA;
            regwrite = 1;
            zero = 0;

            @(posedge clk);
            #2;

            $display("Test Case 001: General data and control signal check");
            #1;

            check_outputs(16'h1234, 1, 16'hABCD, 0, 1, 1, 4'hA, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            aluresult = 16'hAAAA;
            branch = 0;
            data_to_mem = 16'h5555;
            memread = 1;
            memtoreg = 0;
            memwrite = 0;
            regdst = 4'h5;
            regwrite = 0;
            zero = 1;

            @(posedge clk);
            #2;

            $display("Test Case 002: Alternate bit patterns");
            #1;

            check_outputs(16'hAAAA, 0, 16'h5555, 1, 0, 0, 4'h5, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            aluresult = 16'hFFFF;
            branch = 1;
            data_to_mem = 16'hFFFF;
            memread = 1;
            memtoreg = 1;
            memwrite = 1;
            regdst = 4'hF;
            regwrite = 1;
            zero = 1;

            @(posedge clk);
            #2;

            $display("Test Case 003: Maximum values (All 1s)");
            #1;

            check_outputs(16'hFFFF, 1, 16'hFFFF, 1, 1, 1, 4'hF, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            aluresult = 16'h0000;
            branch = 0;
            data_to_mem = 16'h0000;
            memread = 0;
            memtoreg = 0;
            memwrite = 0;
            regdst = 4'h0;
            regwrite = 0;
            zero = 0;

            @(posedge clk);
            #2;

            $display("Test Case 004: Minimum values (All 0s)");
            #1;

            check_outputs(16'h0000, 0, 16'h0000, 0, 0, 0, 4'h0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            aluresult = 16'hF0F0;
            branch = 1;
            data_to_mem = 16'h0F0F;
            memread = 1;
            memtoreg = 0;
            memwrite = 1;
            regdst = 4'hC;
            regwrite = 0;
            zero = 1;

            @(posedge clk);
            #2;

            $display("Test Case 005: Mixed logic check");
            #1;

            check_outputs(16'hF0F0, 1, 16'h0F0F, 1, 0, 1, 4'hC, 0, 1);
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
        input [15:0] expected_aluresultout;
        input expected_branchout;
        input [15:0] expected_data_to_memout;
        input expected_memreadout;
        input expected_memtoregout;
        input expected_memwriteout;
        input [3:0] expected_regdstout;
        input expected_regwriteout;
        input expected_zeroout;
        begin
            if (expected_aluresultout === (expected_aluresultout ^ aluresultout ^ expected_aluresultout) &&
                expected_branchout === (expected_branchout ^ branchout ^ expected_branchout) &&
                expected_data_to_memout === (expected_data_to_memout ^ data_to_memout ^ expected_data_to_memout) &&
                expected_memreadout === (expected_memreadout ^ memreadout ^ expected_memreadout) &&
                expected_memtoregout === (expected_memtoregout ^ memtoregout ^ expected_memtoregout) &&
                expected_memwriteout === (expected_memwriteout ^ memwriteout ^ expected_memwriteout) &&
                expected_regdstout === (expected_regdstout ^ regdstout ^ expected_regdstout) &&
                expected_regwriteout === (expected_regwriteout ^ regwriteout ^ expected_regwriteout) &&
                expected_zeroout === (expected_zeroout ^ zeroout ^ expected_zeroout)) begin
                $display("PASS");
                $display("  Outputs: aluresultout=%h, branchout=%b, data_to_memout=%h, memreadout=%b, memtoregout=%b, memwriteout=%b, regdstout=%h, regwriteout=%b, zeroout=%b",
                         aluresultout, branchout, data_to_memout, memreadout, memtoregout, memwriteout, regdstout, regwriteout, zeroout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluresultout=%h, branchout=%b, data_to_memout=%h, memreadout=%b, memtoregout=%b, memwriteout=%b, regdstout=%h, regwriteout=%b, zeroout=%b",
                         expected_aluresultout, expected_branchout, expected_data_to_memout, expected_memreadout, expected_memtoregout, expected_memwriteout, expected_regdstout, expected_regwriteout, expected_zeroout);
                $display("  Got:      aluresultout=%h, branchout=%b, data_to_memout=%h, memreadout=%b, memtoregout=%b, memwriteout=%b, regdstout=%h, regwriteout=%b, zeroout=%b",
                         aluresultout, branchout, data_to_memout, memreadout, memtoregout, memwriteout, regdstout, regwriteout, zeroout);
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
        $dumpvars(0,aluresult, branch, clk, data_to_mem, memread, memtoreg, memwrite, regdst, regwrite, zero, aluresultout, branchout, data_to_memout, memreadout, memtoregout, memwriteout, regdstout, regwriteout, zeroout);
    end

endmodule
