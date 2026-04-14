`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [68:0] rcn_in;
    reg [31:0] rdata;
    reg rst;
    wire [23:0] addr;
    wire cs;
    wire [3:0] mask;
    wire [68:0] rcn_out;
    wire [31:0] wdata;
    wire wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rcn_in(rcn_in),
        .rdata(rdata),
        .rst(rst),
        .addr(addr),
        .cs(cs),
        .mask(mask),
        .rcn_out(rcn_out),
        .wdata(wdata),
        .wr(wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rcn_in = 69'h0;
            rdata = 32'h0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Basic Write Operation...");
            reset_dut();

            rcn_in = {1'b1, 1'b1, 24'hAABBCC, 4'hF, 32'h12345678, 7'h00};
            @(posedge clk);
            #1;

            check_outputs(24'hAABBCC, 1'b1, 4'hF, rcn_in, 32'h12345678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Basic Read Operation...");
            reset_dut();

            rcn_in = {1'b1, 1'b0, 24'h555555, 4'hE, 32'h0, 7'h00};
            rdata = 32'hDEADBEEF;
            @(posedge clk);
            #1;

            check_outputs(24'h555555, 1'b1, 4'hE, rcn_in, 32'h0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Idle State...");
            reset_dut();

            rcn_in = {1'b0, 1'b1, 24'hFFFFFF, 4'hF, 32'hFFFFFFFF, 7'h7F};
            @(posedge clk);

            #1;


            check_outputs(addr, 1'b0, mask, rcn_out, wdata, wr);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Partial Mask Write...");
            reset_dut();

            rcn_in = {1'b1, 1'b1, 24'h123456, 4'h9, 32'hAAAA5555, 7'h11};
            @(posedge clk);
            #1;

            check_outputs(24'h123456, 1'b1, 4'h9, rcn_in, 32'hAAAA5555, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary Address...");
            reset_dut();

            rcn_in = {1'b1, 1'b1, 24'hFFFFFF, 4'h0, 32'h0, 7'h00};
            @(posedge clk);
            #1;

            check_outputs(24'hFFFFFF, 1'b1, 4'h0, rcn_in, 32'h0, 1'b1);
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
        input [23:0] expected_addr;
        input expected_cs;
        input [3:0] expected_mask;
        input [68:0] expected_rcn_out;
        input [31:0] expected_wdata;
        input expected_wr;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_cs === (expected_cs ^ cs ^ expected_cs) &&
                expected_mask === (expected_mask ^ mask ^ expected_mask) &&
                expected_rcn_out === (expected_rcn_out ^ rcn_out ^ expected_rcn_out) &&
                expected_wdata === (expected_wdata ^ wdata ^ expected_wdata) &&
                expected_wr === (expected_wr ^ wr ^ expected_wr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, cs=%b, mask=%h, rcn_out=%h, wdata=%h, wr=%b",
                         addr, cs, mask, rcn_out, wdata, wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, cs=%b, mask=%h, rcn_out=%h, wdata=%h, wr=%b",
                         expected_addr, expected_cs, expected_mask, expected_rcn_out, expected_wdata, expected_wr);
                $display("  Got:      addr=%h, cs=%b, mask=%h, rcn_out=%h, wdata=%h, wr=%b",
                         addr, cs, mask, rcn_out, wdata, wr);
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
        $dumpvars(0,clk, rcn_in, rdata, rst, addr, cs, mask, rcn_out, wdata, wr);
    end

endmodule
