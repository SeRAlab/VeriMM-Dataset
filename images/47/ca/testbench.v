`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [4:0] CTRL;
    reg clk;
    reg rst;
    wire [31:0] RES;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CTRL(CTRL),
        .clk(clk),
        .rst(rst),
        .RES(RES)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            CTRL = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase002: Addition (0x12 + 0x34)");
            reset_dut();
            A = 32'h00000012;
            B = 32'h00000034;
            CTRL = 5'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000046);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase003: Subtraction (0x50 - 0x20)");
            reset_dut();
            A = 32'h00000050;
            B = 32'h00000020;
            CTRL = 5'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000030);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase004: Bitwise AND");
            reset_dut();
            A = 32'hF0F0F0F0;
            B = 32'hAAAA5555;
            CTRL = 5'd2;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hA0A05050);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase005: Bitwise OR");
            reset_dut();
            A = 32'hF0F0F0F0;
            B = 32'h0F0F0F0F;
            CTRL = 5'd3;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase006: Bitwise XOR");
            reset_dut();
            A = 32'h12345678;
            B = 32'h12345678;
            CTRL = 5'd4;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase007: Logical Shift Left (0x1 << 4)");
            reset_dut();
            A = 32'h00000001;
            B = 32'h00000004;
            CTRL = 5'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000010);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase008: Subtraction (0x5 - 0x10)");
            reset_dut();
            A = 32'h00000005;
            B = 32'h00000010;
            CTRL = 5'd1;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFFFFF5);
        end
        endtask

    task testcase009;

        begin
            $display("Running Testcase009: Addition Overflow");
            reset_dut();
            A = 32'hFFFFFFFF;
            B = 32'h00000001;
            CTRL = 5'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            $display("Running Testcase010: LSL into high bits");
            reset_dut();
            A = 32'h0000FFFF;
            B = 32'h00000010;
            CTRL = 5'd5;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hFFFF0000);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_RES;
        begin
            if (expected_RES === (expected_RES ^ RES ^ expected_RES)) begin
                $display("PASS");
                $display("  Outputs: RES=%h",
                         RES);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RES=%h",
                         expected_RES);
                $display("  Got:      RES=%h",
                         RES);
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
        $dumpvars(0,A, B, CTRL, clk, rst, RES);
    end

endmodule
