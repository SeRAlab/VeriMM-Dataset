`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] rs1;
    reg [4:0] rs2;
    reg stall;
    reg [31:0] w_data;
    reg w_enable;
    reg [4:0] wd;
    wire [31:0] rd1;
    wire [31:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rs1(rs1),
        .rs2(rs2),
        .stall(stall),
        .w_data(w_data),
        .w_enable(w_enable),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            stall = 0;
            w_enable = 0;
            rs1 = 0;
            rs2 = 0;
            wd = 0;
            w_data = 0;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset and read default values");
            reset_dut();
            rs1 = 5;
            rs2 = 10;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write to register 1 and Read back");
            reset_dut();

            wd = 5'd1;
            w_data = 32'hAAAA_BBBB;
            w_enable = 1;
            @(posedge clk);
            #2;
            w_enable = 0;

            rs1 = 5'd1;
            rs2 = 5'd0;
            #5;
            #1;

            check_outputs(32'hAAAA_BBBB, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify w_enable logic");
            reset_dut();

            wd = 5'd2;
            w_data = 32'hDEAD_BEEF;
            w_enable = 0;
            @(posedge clk);
            #2;

            rs1 = 5'd2;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Verify stall logic");
            reset_dut();

            wd = 5'd3;
            w_data = 32'h1234_5678;
            w_enable = 1;
            stall = 1;
            @(posedge clk);
            #2;
            stall = 0;
            w_enable = 0;

            rs1 = 5'd3;
            #5;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dual port read check");
            reset_dut();

            wd = 5'd10; w_data = 32'h1111_1111; w_enable = 1;
            @(posedge clk); #2;

            wd = 5'd20; w_data = 32'h2222_2222; w_enable = 1;
            @(posedge clk); #2;
            w_enable = 0;

            rs1 = 5'd10;
            rs2 = 5'd20;
            #5;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Write and read the last register (31)");
            reset_dut();
            wd = 5'd31;
            w_data = 32'hFFFF_FFFF;
            w_enable = 1;
            @(posedge clk);
            #2;
            w_enable = 0;
            rs1 = 5'd31;
            rs2 = 5'd31;
            #5;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Overwriting an existing value in register 15");
            reset_dut();

            wd = 5'd15; w_data = 32'h0000_1111; w_enable = 1;
            @(posedge clk); #2;

            wd = 5'd15; w_data = 32'hEEEE_FFFF; w_enable = 1;
            @(posedge clk); #2;
            w_enable = 0;
            rs1 = 5'd15;
            #5;
            #1;

            check_outputs(32'hEEEE_FFFF, 32'h0);
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
        input [31:0] expected_rd1;
        input [31:0] expected_rd2;
        begin
            if (expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1) &&
                expected_rd2 === (expected_rd2 ^ rd2 ^ expected_rd2)) begin
                $display("PASS");
                $display("  Outputs: rd1=%h, rd2=%h",
                         rd1, rd2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1=%h, rd2=%h",
                         expected_rd1, expected_rd2);
                $display("  Got:      rd1=%h, rd2=%h",
                         rd1, rd2);
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
        $dumpvars(0,clk, reset, rs1, rs2, stall, w_data, w_enable, wd, rd1, rd2);
    end

endmodule
