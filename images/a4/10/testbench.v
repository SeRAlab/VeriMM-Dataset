`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg core_reg_ack;
    reg [31:0] core_reg_rd_data;
    reg [31:0] reg_addr;
    reg reg_rd_wr_L;
    reg reg_req;
    reg [31:0] reg_wr_data;
    reg reset;
    reg udp_reg_ack;
    reg [31:0] udp_reg_rd_data;
    wire [31:0] core_reg_addr;
    wire core_reg_rd_wr_L;
    wire core_reg_req;
    wire [31:0] core_reg_wr_data;
    wire reg_ack;
    wire [31:0] reg_rd_data;
    wire [31:0] udp_reg_addr;
    wire udp_reg_rd_wr_L;
    wire udp_reg_req;
    wire [31:0] udp_reg_wr_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .core_reg_ack(core_reg_ack),
        .core_reg_rd_data(core_reg_rd_data),
        .reg_addr(reg_addr),
        .reg_rd_wr_L(reg_rd_wr_L),
        .reg_req(reg_req),
        .reg_wr_data(reg_wr_data),
        .reset(reset),
        .udp_reg_ack(udp_reg_ack),
        .udp_reg_rd_data(udp_reg_rd_data),
        .core_reg_addr(core_reg_addr),
        .core_reg_rd_wr_L(core_reg_rd_wr_L),
        .core_reg_req(core_reg_req),
        .core_reg_wr_data(core_reg_wr_data),
        .reg_ack(reg_ack),
        .reg_rd_data(reg_rd_data),
        .udp_reg_addr(udp_reg_addr),
        .udp_reg_rd_wr_L(udp_reg_rd_wr_L),
        .udp_reg_req(udp_reg_req),
        .udp_reg_wr_data(udp_reg_wr_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            reg_req = 0;
            reg_rd_wr_L = 0;
            reg_addr = 0;
            reg_wr_data = 0;
            core_reg_ack = 0;
            core_reg_rd_data = 0;
            udp_reg_ack = 0;
            udp_reg_rd_data = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(32'h0, 0, 0, 32'h0, 0, 32'h0, 32'h0, 0, 0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Core Register Write");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            reg_req = 1;
            reg_rd_wr_L = 0;
            reg_addr = 32'h0000_1234;
            reg_wr_data = 32'hAAAA_BBBB;
            core_reg_ack = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_1234, 0, 1, 32'hAAAA_BBBB, 1, 32'h0, 32'h0, 0, 0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Core Register Read");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 32'h0000_5555;
            core_reg_ack = 1;
            core_reg_rd_data = 32'h1234_5678;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000_5555, 1, 1, 32'h0, 1, 32'h1234_5678, 32'h0, 0, 0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: UDP Register Write");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            reg_req = 1;
            reg_rd_wr_L = 0;
            reg_addr = 32'h0001_ABCD;
            reg_wr_data = 32'hDE1E_CA7E;
            udp_reg_ack = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 0, 32'h0, 1, 32'h0, 32'h0001_ABCD, 0, 1, 32'hDE1E_CA7E);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: UDP Register Read");
            test_num = 5;
            reset_dut();
            @(posedge clk);
            reg_req = 1;
            reg_rd_wr_L = 1;
            reg_addr = 32'h0001_FFFF;
            udp_reg_ack = 1;
            udp_reg_rd_data = 32'h8765_4321;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 0, 32'h0, 1, 32'h8765_4321, 32'h0001_FFFF, 1, 1, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Idle State");
            test_num = 6;
            reset_dut();
            @(posedge clk);
            reg_req = 0;
            reg_addr = 32'h0000_1111;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 0, 0, 32'h0, 0, 32'h0, 32'h0, 0, 0, 32'h0);
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
        input [31:0] expected_core_reg_addr;
        input expected_core_reg_rd_wr_L;
        input expected_core_reg_req;
        input [31:0] expected_core_reg_wr_data;
        input expected_reg_ack;
        input [31:0] expected_reg_rd_data;
        input [31:0] expected_udp_reg_addr;
        input expected_udp_reg_rd_wr_L;
        input expected_udp_reg_req;
        input [31:0] expected_udp_reg_wr_data;
        begin
            if (expected_core_reg_addr === (expected_core_reg_addr ^ core_reg_addr ^ expected_core_reg_addr) &&
                expected_core_reg_rd_wr_L === (expected_core_reg_rd_wr_L ^ core_reg_rd_wr_L ^ expected_core_reg_rd_wr_L) &&
                expected_core_reg_req === (expected_core_reg_req ^ core_reg_req ^ expected_core_reg_req) &&
                expected_core_reg_wr_data === (expected_core_reg_wr_data ^ core_reg_wr_data ^ expected_core_reg_wr_data) &&
                expected_reg_ack === (expected_reg_ack ^ reg_ack ^ expected_reg_ack) &&
                expected_reg_rd_data === (expected_reg_rd_data ^ reg_rd_data ^ expected_reg_rd_data) &&
                expected_udp_reg_addr === (expected_udp_reg_addr ^ udp_reg_addr ^ expected_udp_reg_addr) &&
                expected_udp_reg_rd_wr_L === (expected_udp_reg_rd_wr_L ^ udp_reg_rd_wr_L ^ expected_udp_reg_rd_wr_L) &&
                expected_udp_reg_req === (expected_udp_reg_req ^ udp_reg_req ^ expected_udp_reg_req) &&
                expected_udp_reg_wr_data === (expected_udp_reg_wr_data ^ udp_reg_wr_data ^ expected_udp_reg_wr_data)) begin
                $display("PASS");
                $display("  Outputs: core_reg_addr=%h, core_reg_rd_wr_L=%b, core_reg_req=%b, core_reg_wr_data=%h, reg_ack=%b, reg_rd_data=%h, udp_reg_addr=%h, udp_reg_rd_wr_L=%b, udp_reg_req=%b, udp_reg_wr_data=%h",
                         core_reg_addr, core_reg_rd_wr_L, core_reg_req, core_reg_wr_data, reg_ack, reg_rd_data, udp_reg_addr, udp_reg_rd_wr_L, udp_reg_req, udp_reg_wr_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: core_reg_addr=%h, core_reg_rd_wr_L=%b, core_reg_req=%b, core_reg_wr_data=%h, reg_ack=%b, reg_rd_data=%h, udp_reg_addr=%h, udp_reg_rd_wr_L=%b, udp_reg_req=%b, udp_reg_wr_data=%h",
                         expected_core_reg_addr, expected_core_reg_rd_wr_L, expected_core_reg_req, expected_core_reg_wr_data, expected_reg_ack, expected_reg_rd_data, expected_udp_reg_addr, expected_udp_reg_rd_wr_L, expected_udp_reg_req, expected_udp_reg_wr_data);
                $display("  Got:      core_reg_addr=%h, core_reg_rd_wr_L=%b, core_reg_req=%b, core_reg_wr_data=%h, reg_ack=%b, reg_rd_data=%h, udp_reg_addr=%h, udp_reg_rd_wr_L=%b, udp_reg_req=%b, udp_reg_wr_data=%h",
                         core_reg_addr, core_reg_rd_wr_L, core_reg_req, core_reg_wr_data, reg_ack, reg_rd_data, udp_reg_addr, udp_reg_rd_wr_L, udp_reg_req, udp_reg_wr_data);
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
        $dumpvars(0,clk, core_reg_ack, core_reg_rd_data, reg_addr, reg_rd_wr_L, reg_req, reg_wr_data, reset, udp_reg_ack, udp_reg_rd_data, core_reg_addr, core_reg_rd_wr_L, core_reg_req, core_reg_wr_data, reg_ack, reg_rd_data, udp_reg_addr, udp_reg_rd_wr_L, udp_reg_req, udp_reg_wr_data);
    end

endmodule
