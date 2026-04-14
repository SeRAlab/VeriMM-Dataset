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
        M_alu_out = 0; M_flush = 0; M_memtoreg = 0; M_readdata = 0;
        M_regwrite = 0; M_rt_rd = 0; M_stall = 0; WB_stall = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Reset State Verification", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 1'b0, 32'h0, 1'b0, 5'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Normal Data Propagation", test_num);
        reset_dut();
        @(negedge clk);
        M_alu_out = 32'hAAAA_BBBB;
        M_readdata = 32'h1234_5678;
        M_rt_rd = 5'd15;
        M_regwrite = 1'b1;
        M_memtoreg = 1'b0;
        M_flush = 1'b0;
        M_stall = 1'b0;
        WB_stall = 1'b0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB, 1'b0, 32'h1234_5678, 1'b1, 5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Flush Mechanism Check", test_num);
        reset_dut();
        @(negedge clk);
        M_alu_out = 32'hCCCC_DDDD;
        M_readdata = 32'h8765_4321;
        M_rt_rd = 5'd31;
        M_regwrite = 1'b1;
        M_memtoreg = 1'b1;
        M_flush = 1'b1;
        M_stall = 1'b0;
        WB_stall = 1'b0;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hCCCC_DDDD, 1'b1, 32'h8765_4321, 1'b0, 5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Stall (M_stall) Preservation", test_num);
        reset_dut();

        @(negedge clk);
        M_alu_out = 32'h1111_1111; M_rt_rd = 5'd1; M_regwrite = 1;
        @(posedge clk);
        #1;

        @(negedge clk);
        M_stall = 1'b1;
        M_alu_out = 32'hEEEE_FFFF; M_rt_rd = 5'd2;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h1111_1111, 1'b0, 32'h0, 1'b1, 5'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Stall (WB_stall) Preservation", test_num);
        reset_dut();

        @(negedge clk);
        M_alu_out = 32'hAAAA_AAAA; M_rt_rd = 5'd10; M_regwrite = 1;
        @(posedge clk);
        #1;

        @(negedge clk);
        WB_stall = 1'b1;
        M_alu_out = 32'hBBBB_BBBB; M_rt_rd = 5'd20;
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'hAAAA_AAAA, 1'b0, 32'h0, 1'b1, 5'd10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple Cycle Sequential Data", test_num);
        reset_dut();


        @(negedge clk);
        M_alu_out = 32'h0000_0001; M_rt_rd = 5'd1; M_regwrite = 1;
        @(posedge clk);


        @(negedge clk);
        M_alu_out = 32'h0000_0002; M_rt_rd = 5'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0000_0002, 1'b0, 32'h0, 1'b1, 5'd2);
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
