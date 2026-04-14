`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] reg_R_addr_A;
    reg [4:0] reg_R_addr_B;
    reg [4:0] reg_W_addr;
    reg reg_we;
    reg rst;
    reg [31:0] wdata;
    wire [31:0] rdata_A;
    wire [31:0] rdata_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reg_R_addr_A(reg_R_addr_A),
        .reg_R_addr_B(reg_R_addr_B),
        .reg_W_addr(reg_W_addr),
        .reg_we(reg_we),
        .rst(rst),
        .wdata(wdata),
        .rdata_A(rdata_A),
        .rdata_B(rdata_B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        reg_we = 0;
        reg_W_addr = 0;
        wdata = 0;
        reg_R_addr_A = 0;
        reg_R_addr_B = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Verify reset state", test_num);
        reset_dut();
        reg_R_addr_A = 5'd10;
        reg_R_addr_B = 5'd20;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Write to Register 5 and read back", test_num);
        reset_dut();
        @(negedge clk);
        reg_W_addr = 5'd5;
        wdata = 32'hDEADBEEF;
        reg_we = 1;
        @(posedge clk);
        #1 reg_we = 0;
        reg_R_addr_A = 5'd5;
        reg_R_addr_B = 5'd0;
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Attempt write to Register 0 (should remain 0)", test_num);
        reset_dut();
        @(negedge clk);
        reg_W_addr = 5'd0;
        wdata = 32'hFFFFFFFF;
        reg_we = 1;
        @(posedge clk);
        #1 reg_we = 0;
        reg_R_addr_A = 5'd0;
        reg_R_addr_B = 5'd0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Simultaneous read from Port A and Port B", test_num);
        reset_dut();

        @(negedge clk);
        reg_W_addr = 5'd1; wdata = 32'h11111111; reg_we = 1;
        @(posedge clk);

        @(negedge clk);
        reg_W_addr = 5'd2; wdata = 32'h22222222; reg_we = 1;
        @(posedge clk);
        #1 reg_we = 0;
        reg_R_addr_A = 5'd1;
        reg_R_addr_B = 5'd2;
        #2;
        #1;

        check_outputs(32'h11111111, 32'h22222222);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Write with reg_we = 0 (should not update)", test_num);
        reset_dut();
        @(negedge clk);
        reg_W_addr = 5'd15;
        wdata = 32'hABCDE000;
        reg_we = 0;
        @(posedge clk);
        reg_R_addr_A = 5'd15;
        reg_R_addr_B = 5'd0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overwrite register value", test_num);
        reset_dut();

        @(negedge clk);
        reg_W_addr = 5'd31; wdata = 32'hAAAA_AAAA; reg_we = 1;
        @(posedge clk);

        @(negedge clk);
        reg_W_addr = 5'd31; wdata = 32'hBBBB_BBBB; reg_we = 1;
        @(posedge clk);
        #1 reg_we = 0;
        reg_R_addr_A = 5'd31;
        reg_R_addr_B = 5'd31;
        #2;
        #1;

        check_outputs(32'hBBBB_BBBB, 32'hBBBB_BBBB);
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
        input [31:0] expected_rdata_A;
        input [31:0] expected_rdata_B;
        begin
            if (expected_rdata_A === (expected_rdata_A ^ rdata_A ^ expected_rdata_A) &&
                expected_rdata_B === (expected_rdata_B ^ rdata_B ^ expected_rdata_B)) begin
                $display("PASS");
                $display("  Outputs: rdata_A=%h, rdata_B=%h",
                         rdata_A, rdata_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata_A=%h, rdata_B=%h",
                         expected_rdata_A, expected_rdata_B);
                $display("  Got:      rdata_A=%h, rdata_B=%h",
                         rdata_A, rdata_B);
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
        $dumpvars(0,clk, reg_R_addr_A, reg_R_addr_B, reg_W_addr, reg_we, rst, wdata, rdata_A, rdata_B);
    end

endmodule
