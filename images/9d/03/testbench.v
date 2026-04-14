`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] mem_hi;
    reg [31:0] mem_lo;
    reg [4:0] mem_waddr;
    reg [31:0] mem_wdata;
    reg mem_we;
    reg mem_whilo;
    reg reset_n;
    wire [4:0] wb_hi;
    wire [31:0] wb_lo;
    wire [4:0] wb_waddr;
    wire [31:0] wb_wdata;
    wire wb_we;
    wire wb_whilo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_hi(mem_hi),
        .mem_lo(mem_lo),
        .mem_waddr(mem_waddr),
        .mem_wdata(mem_wdata),
        .mem_we(mem_we),
        .mem_whilo(mem_whilo),
        .reset_n(reset_n),
        .wb_hi(wb_hi),
        .wb_lo(wb_lo),
        .wb_waddr(wb_waddr),
        .wb_wdata(wb_wdata),
        .wb_we(wb_we),
        .wb_whilo(wb_whilo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        mem_hi = 0;
        mem_lo = 0;
        mem_waddr = 0;
        mem_wdata = 0;
        mem_we = 0;
        mem_whilo = 0;
        @(posedge clk);
        #1;
        reset_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Verifying Reset State", test_num);
        reset_n = 0;
        mem_hi = 5'h1F; mem_lo = 32'hFFFFFFFF;
        mem_waddr = 5'h1F; mem_wdata = 32'hFFFFFFFF;
        mem_we = 1; mem_whilo = 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(5'd0, 32'd0, 5'd0, 32'd0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Normal Register Write Propagation", test_num);
        reset_dut();
        mem_we = 1;
        mem_waddr = 5'd15;
        mem_wdata = 32'hDEADBEEF;
        mem_whilo = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(5'd0, 32'd0, 5'd15, 32'hDEADBEEF, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: HI/LO Data Propagation", test_num);
        reset_dut();
        mem_we = 0;
        mem_whilo = 1;
        mem_hi = 5'h0A;
        mem_lo = 32'h12345678;
        @(posedge clk);
        #2;
        #1;

        check_outputs(5'h0A, 32'h12345678, 5'd0, 32'd0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Simultaneous Register and HI/LO Propagation", test_num);
        reset_dut();
        mem_we = 1;
        mem_waddr = 5'd31;
        mem_wdata = 32'hAAAA5555;
        mem_whilo = 1;
        mem_hi = 5'h15;
        mem_lo = 32'h5555AAAA;
        @(posedge clk);
        #2;
        #1;

        check_outputs(5'h15, 32'h5555AAAA, 5'd31, 32'hAAAA5555, 1'b1, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify Disabled Write Propagation", test_num);
        reset_dut();
        mem_we = 0;
        mem_waddr = 5'd10;
        mem_wdata = 32'h11223344;
        mem_whilo = 0;
        mem_hi = 5'h05;
        mem_lo = 32'h55667788;
        @(posedge clk);
        #2;

        #1;


        check_outputs(5'h05, 32'h55667788, 5'd10, 32'h11223344, 1'b0, 1'b0);
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
        input [4:0] expected_wb_hi;
        input [31:0] expected_wb_lo;
        input [4:0] expected_wb_waddr;
        input [31:0] expected_wb_wdata;
        input expected_wb_we;
        input expected_wb_whilo;
        begin
            if (expected_wb_hi === (expected_wb_hi ^ wb_hi ^ expected_wb_hi) &&
                expected_wb_lo === (expected_wb_lo ^ wb_lo ^ expected_wb_lo) &&
                expected_wb_waddr === (expected_wb_waddr ^ wb_waddr ^ expected_wb_waddr) &&
                expected_wb_wdata === (expected_wb_wdata ^ wb_wdata ^ expected_wb_wdata) &&
                expected_wb_we === (expected_wb_we ^ wb_we ^ expected_wb_we) &&
                expected_wb_whilo === (expected_wb_whilo ^ wb_whilo ^ expected_wb_whilo)) begin
                $display("PASS");
                $display("  Outputs: wb_hi=%h, wb_lo=%h, wb_waddr=%h, wb_wdata=%h, wb_we=%b, wb_whilo=%b",
                         wb_hi, wb_lo, wb_waddr, wb_wdata, wb_we, wb_whilo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: wb_hi=%h, wb_lo=%h, wb_waddr=%h, wb_wdata=%h, wb_we=%b, wb_whilo=%b",
                         expected_wb_hi, expected_wb_lo, expected_wb_waddr, expected_wb_wdata, expected_wb_we, expected_wb_whilo);
                $display("  Got:      wb_hi=%h, wb_lo=%h, wb_waddr=%h, wb_wdata=%h, wb_we=%b, wb_whilo=%b",
                         wb_hi, wb_lo, wb_waddr, wb_wdata, wb_we, wb_whilo);
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
        $dumpvars(0,clk, mem_hi, mem_lo, mem_waddr, mem_wdata, mem_we, mem_whilo, reset_n, wb_hi, wb_lo, wb_waddr, wb_wdata, wb_we, wb_whilo);
    end

endmodule
