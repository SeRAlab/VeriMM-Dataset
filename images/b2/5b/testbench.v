`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] rg_rd_addr1;
    reg [2:0] rg_rd_addr2;
    reg [15:0] rg_wrt_data;
    reg [2:0] rg_wrt_dest;
    reg rg_wrt_enable;
    reg rst;
    wire [15:0] rg_rd_data1;
    wire [15:0] rg_rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rg_rd_addr1(rg_rd_addr1),
        .rg_rd_addr2(rg_rd_addr2),
        .rg_wrt_data(rg_wrt_data),
        .rg_wrt_dest(rg_wrt_dest),
        .rg_wrt_enable(rg_wrt_enable),
        .rst(rst),
        .rg_rd_data1(rg_rd_data1),
        .rg_rd_data2(rg_rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        rg_wrt_enable = 0;
        rg_wrt_dest = 0;
        rg_wrt_data = 0;
        rg_rd_addr1 = 0;
        rg_rd_addr2 = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();

        rg_rd_addr1 = 3'd0;
        rg_rd_addr2 = 3'd7;
        #2;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Write and Dual Port Read", test_num);
        reset_dut();
        @(negedge clk);
        rg_wrt_enable = 1;
        rg_wrt_dest = 3'd1;
        rg_wrt_data = 16'hABCD;
        @(posedge clk);
        #1;
        rg_wrt_enable = 0;
        rg_rd_addr1 = 3'd1;
        rg_rd_addr2 = 3'd0;
        #2;
        #1;

        check_outputs(16'hABCD, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Multiple Writes to Different Addresses", test_num);
        reset_dut();

        @(negedge clk);
        rg_wrt_enable = 1;
        rg_wrt_dest = 3'd2;
        rg_wrt_data = 16'h1111;
        @(posedge clk);

        @(negedge clk);
        rg_wrt_dest = 3'd5;
        rg_wrt_data = 16'h5555;
        @(posedge clk);
        #1;
        rg_wrt_enable = 0;
        rg_rd_addr1 = 3'd2;
        rg_rd_addr2 = 3'd5;
        #2;
        #1;

        check_outputs(16'h1111, 16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Write Enable Disable Check", test_num);
        reset_dut();
        @(negedge clk);
        rg_wrt_enable = 0;
        rg_wrt_dest = 3'd3;
        rg_wrt_data = 16'hFFFF;
        @(posedge clk);
        #1;
        rg_rd_addr1 = 3'd3;
        rg_rd_addr2 = 3'd0;
        #2;

        #1;


        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overwrite Existing Data", test_num);
        reset_dut();

        @(negedge clk);
        rg_wrt_enable = 1;
        rg_wrt_dest = 3'd4;
        rg_wrt_data = 16'hAAAA;
        @(posedge clk);

        @(negedge clk);
        rg_wrt_data = 16'hBBBB;
        @(posedge clk);
        #1;
        rg_wrt_enable = 0;
        rg_rd_addr1 = 3'd4;
        rg_rd_addr2 = 3'd4;
        #2;
        #1;

        check_outputs(16'hBBBB, 16'hBBBB);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary Address Check (Reg 0 and Reg 7)", test_num);
        reset_dut();
        @(negedge clk);
        rg_wrt_enable = 1;
        rg_wrt_dest = 3'd0;
        rg_wrt_data = 16'hCAFE;
        @(posedge clk);
        @(negedge clk);
        rg_wrt_dest = 3'd7;
        rg_wrt_data = 16'hBEEF;
        @(posedge clk);
        #1;
        rg_wrt_enable = 0;
        rg_rd_addr1 = 3'd0;
        rg_rd_addr2 = 3'd7;
        #2;
        #1;

        check_outputs(16'hCAFE, 16'hBEEF);
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
        input [15:0] expected_rg_rd_data1;
        input [15:0] expected_rg_rd_data2;
        begin
            if (expected_rg_rd_data1 === (expected_rg_rd_data1 ^ rg_rd_data1 ^ expected_rg_rd_data1) &&
                expected_rg_rd_data2 === (expected_rg_rd_data2 ^ rg_rd_data2 ^ expected_rg_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rg_rd_data1=%h, rg_rd_data2=%h",
                         rg_rd_data1, rg_rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rg_rd_data1=%h, rg_rd_data2=%h",
                         expected_rg_rd_data1, expected_rg_rd_data2);
                $display("  Got:      rg_rd_data1=%h, rg_rd_data2=%h",
                         rg_rd_data1, rg_rd_data2);
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
        $dumpvars(0,clk, rg_rd_addr1, rg_rd_addr2, rg_wrt_data, rg_wrt_dest, rg_wrt_enable, rst, rg_rd_data1, rg_rd_data2);
    end

endmodule
