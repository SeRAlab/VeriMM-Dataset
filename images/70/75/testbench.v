`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] rd_data_in;
    reg [4:0] rd_offset;
    reg [4:0] rs1_offset;
    reg [4:0] rs2_offset;
    reg rst;
    reg write_enable;
    wire [31:0] rs1_data_out;
    wire [31:0] rs2_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_data_in(rd_data_in),
        .rd_offset(rd_offset),
        .rs1_offset(rs1_offset),
        .rs2_offset(rs2_offset),
        .rst(rst),
        .write_enable(write_enable),
        .rs1_data_out(rs1_data_out),
        .rs2_data_out(rs2_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            write_enable = 0;
            rd_offset = 0;
            rd_data_in = 0;
            rs1_offset = 0;
            rs2_offset = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read...");
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            rd_offset = 5'd1;
            rd_data_in = 32'h12345678;

            @(posedge clk);
            write_enable = 0;
            rs1_offset = 5'd1;
            rs2_offset = 5'd1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple Register Access...");
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            rd_offset = 5'd10;
            rd_data_in = 32'hAAAA_BBBB;


            @(posedge clk);
            rd_offset = 5'd20;
            rd_data_in = 32'hCCCC_DDDD;

            @(posedge clk);
            write_enable = 0;
            rs1_offset = 5'd10;
            rs2_offset = 5'd20;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable Verification...");
            reset_dut();


            @(posedge clk);
            write_enable = 0;
            rd_offset = 5'd5;
            rd_data_in = 32'hFFFF_FFFF;

            @(posedge clk);
            rs1_offset = 5'd5;
            rs2_offset = 5'd0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Register 31 Boundary Test...");
            reset_dut();

            @(posedge clk);
            write_enable = 1;
            rd_offset = 5'd31;
            rd_data_in = 32'h55AA_55AA;

            @(posedge clk);
            write_enable = 0;
            rs1_offset = 5'd31;
            rs2_offset = 5'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA_55AA, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite Test...");
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            rd_offset = 5'd15;
            rd_data_in = 32'h1111_1111;


            @(posedge clk);
            rd_offset = 5'd15;
            rd_data_in = 32'h2222_2222;

            @(posedge clk);
            write_enable = 0;
            rs1_offset = 5'd15;
            rs2_offset = 5'd15;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Reset Mid-Operation...");
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            rd_offset = 5'd8;
            rd_data_in = 32'h8888_8888;


            @(posedge clk);
            rst = 1;

            @(posedge clk);
            rst = 0;
            write_enable = 0;
            rs1_offset = 5'd8;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
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
        input [31:0] expected_rs1_data_out;
        input [31:0] expected_rs2_data_out;
        begin
            if (expected_rs1_data_out === (expected_rs1_data_out ^ rs1_data_out ^ expected_rs1_data_out) &&
                expected_rs2_data_out === (expected_rs2_data_out ^ rs2_data_out ^ expected_rs2_data_out)) begin
                $display("PASS");
                $display("  Outputs: rs1_data_out=%h, rs2_data_out=%h",
                         rs1_data_out, rs2_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rs1_data_out=%h, rs2_data_out=%h",
                         expected_rs1_data_out, expected_rs2_data_out);
                $display("  Got:      rs1_data_out=%h, rs2_data_out=%h",
                         rs1_data_out, rs2_data_out);
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
        $dumpvars(0,clk, rd_data_in, rd_offset, rs1_offset, rs2_offset, rst, write_enable, rs1_data_out, rs2_data_out);
    end

endmodule
