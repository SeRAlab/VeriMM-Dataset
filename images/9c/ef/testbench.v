`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] M_alu_out;
    reg M_flush;
    reg M_memtoreg;
    reg [31:0] M_readdata;
    reg M_regwrite;
    reg [4:0] M_rt_rd;
    reg M_stall;
    reg WB_stall;
    reg clk;
    reg rst;
    wire [31:0] WB_alu_out;
    wire WB_memtoreg;
    wire [31:0] WB_readdata;
    wire WB_regwrite;
    wire [4:0] WB_rt_rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M_alu_out(M_alu_out),
        .M_flush(M_flush),
        .M_memtoreg(M_memtoreg),
        .M_readdata(M_readdata),
        .M_regwrite(M_regwrite),
        .M_rt_rd(M_rt_rd),
        .M_stall(M_stall),
        .WB_stall(WB_stall),
        .clk(clk),
        .rst(rst),
        .WB_alu_out(WB_alu_out),
        .WB_memtoreg(WB_memtoreg),
        .WB_readdata(WB_readdata),
        .WB_regwrite(WB_regwrite),
        .WB_rt_rd(WB_rt_rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        M_alu_out = 0;
        M_flush = 0;
        M_memtoreg = 0;
        M_readdata = 0;
        M_regwrite = 0;
        M_rt_rd = 0;
        M_stall = 0;
        WB_stall = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Basic Data Pass-through", test_num);
        reset_dut();

        M_alu_out = 32'h12345678;
        M_readdata = 32'h87654321;
        M_rt_rd = 5'h0A;
        M_regwrite = 1'b1;
        M_memtoreg = 1'b0;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h12345678, 1'b0, 32'h87654321, 1'b1, 5'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Flush Functionality", test_num);
        reset_dut();


        M_alu_out = 32'hAAAAAAAA;
        M_readdata = 32'hBBBBBBBB;
        M_rt_rd = 5'h1F;
        M_regwrite = 1'b1;
        M_memtoreg = 1'b1;
        M_flush = 1'b1;

        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 5'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Memory Stage Stall (M_stall)", test_num);
        reset_dut();


        M_alu_out = 32'h55555555;
        M_rt_rd = 5'h05;
        M_regwrite = 1'b1;
        @(posedge clk);
        #1;


        M_stall = 1'b1;
        M_alu_out = 32'hFFFFFFFF;
        M_rt_rd = 5'h10;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'h55555555, 1'b0, 32'h0, 1'b1, 5'h05);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Writeback Stage Stall (WB_stall)", test_num);
        reset_dut();


        M_alu_out = 32'hCCCCDDDD;
        M_rt_rd = 5'h12;
        M_regwrite = 1'b1;
        @(posedge clk);
        #1;


        WB_stall = 1'b1;
        M_alu_out = 32'h00000000;
        M_rt_rd = 5'h00;

        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hCCCCDDDD, 1'b0, 32'h0, 1'b1, 5'h12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Reset during operation", test_num);
        reset_dut();


        M_alu_out = 32'h11223344;
        M_regwrite = 1'b1;
        @(posedge clk);
        #1;


        rst = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 5'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Release Stall", test_num);
        reset_dut();


        M_stall = 1'b1;
        M_alu_out = 32'hFEEDFACE;
        M_rt_rd = 5'h01;
        @(posedge clk);
        #1;


        M_stall = 1'b0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(32'hFEEDFACE, 1'b0, 32'h0, 1'b0, 5'h01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Flush and Stall concurrent", test_num);
        reset_dut();


        M_alu_out = 32'h88888888;
        M_rt_rd = 5'h11;
        @(posedge clk);
        #1;


        M_flush = 1'b1;
        M_stall = 1'b1;
        M_alu_out = 32'h99999999;

        @(posedge clk);
        #2;




        #1;





        check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 5'h0);
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
        testcase007();
        
        
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
        input [31:0] expected_WB_alu_out;
        input expected_WB_memtoreg;
        input [31:0] expected_WB_readdata;
        input expected_WB_regwrite;
        input [4:0] expected_WB_rt_rd;
        begin
            if (expected_WB_alu_out === (expected_WB_alu_out ^ WB_alu_out ^ expected_WB_alu_out) &&
                expected_WB_memtoreg === (expected_WB_memtoreg ^ WB_memtoreg ^ expected_WB_memtoreg) &&
                expected_WB_readdata === (expected_WB_readdata ^ WB_readdata ^ expected_WB_readdata) &&
                expected_WB_regwrite === (expected_WB_regwrite ^ WB_regwrite ^ expected_WB_regwrite) &&
                expected_WB_rt_rd === (expected_WB_rt_rd ^ WB_rt_rd ^ expected_WB_rt_rd)) begin
                $display("PASS");
                $display("  Outputs: WB_alu_out=%h, WB_memtoreg=%b, WB_readdata=%h, WB_regwrite=%b, WB_rt_rd=%h",
                         WB_alu_out, WB_memtoreg, WB_readdata, WB_regwrite, WB_rt_rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: WB_alu_out=%h, WB_memtoreg=%b, WB_readdata=%h, WB_regwrite=%b, WB_rt_rd=%h",
                         expected_WB_alu_out, expected_WB_memtoreg, expected_WB_readdata, expected_WB_regwrite, expected_WB_rt_rd);
                $display("  Got:      WB_alu_out=%h, WB_memtoreg=%b, WB_readdata=%h, WB_regwrite=%b, WB_rt_rd=%h",
                         WB_alu_out, WB_memtoreg, WB_readdata, WB_regwrite, WB_rt_rd);
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
        $dumpvars(0,M_alu_out, M_flush, M_memtoreg, M_readdata, M_regwrite, M_rt_rd, M_stall, WB_stall, clk, rst, WB_alu_out, WB_memtoreg, WB_readdata, WB_regwrite, WB_rt_rd);
    end

endmodule
