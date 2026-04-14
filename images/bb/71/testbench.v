`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_6MB;
    reg [15:0] PC;
    reg SHADOW;
    reg nBNKB;
    wire [6:0] VIDEO_B;
    wire [6:0] VIDEO_G;
    wire [6:0] VIDEO_R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_6MB(CLK_6MB),
        .PC(PC),
        .SHADOW(SHADOW),
        .nBNKB(nBNKB),
        .VIDEO_B(VIDEO_B),
        .VIDEO_G(VIDEO_G),
        .VIDEO_R(VIDEO_R)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_6MB = 0;
        forever #5 CLK_6MB = ~CLK_6MB;
    end

        task reset_dut;

    begin
        nBNKB = 1;
        PC = 16'h0;
        SHADOW = 0;
        @(posedge CLK_6MB);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        nBNKB = 1;
        PC = 16'hFFFF;
        SHADOW = 1;
        @(posedge CLK_6MB);
        #1;
        $display("Testcase 001: Blanking (nBNKB=1)");
        #1;

        check_outputs(7'h00, 7'h00, 7'h00);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        nBNKB = 0;
        SHADOW = 0;
        PC = 16'hFFFF;
        @(posedge CLK_6MB);
        #1;
        $display("Testcase 002: Enabled, Shadow 0, Max PC");

        #1;


        check_outputs(7'h3C, 7'h3F, 7'h3F);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        nBNKB = 0;
        SHADOW = 1;
        PC = 16'h0000;
        @(posedge CLK_6MB);
        #1;
        $display("Testcase 003: Enabled, Shadow 1, Min PC");

        #1;


        check_outputs(7'h40, 7'h40, 7'h40);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        nBNKB = 0;
        SHADOW = 0;
        PC = 16'hA5A5;

        @(posedge CLK_6MB);
        #1;
        $display("Testcase 004: Pattern 16'hA5A5, Shadow 0");
        #1;

        check_outputs(7'h28, 7'h1A, 7'h25);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        nBNKB = 0;
        SHADOW = 1;
        PC = 16'h5A5A;


        @(posedge CLK_6MB);
        #1;
        $display("Testcase 005: Pattern 16'h5A5A, Shadow 1");
        #1;

        check_outputs(7'h54, 7'h65, 7'h5A);
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
        input [6:0] expected_VIDEO_B;
        input [6:0] expected_VIDEO_G;
        input [6:0] expected_VIDEO_R;
        begin
            if (expected_VIDEO_B === (expected_VIDEO_B ^ VIDEO_B ^ expected_VIDEO_B) &&
                expected_VIDEO_G === (expected_VIDEO_G ^ VIDEO_G ^ expected_VIDEO_G) &&
                expected_VIDEO_R === (expected_VIDEO_R ^ VIDEO_R ^ expected_VIDEO_R)) begin
                $display("PASS");
                $display("  Outputs: VIDEO_B=%h, VIDEO_G=%h, VIDEO_R=%h",
                         VIDEO_B, VIDEO_G, VIDEO_R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: VIDEO_B=%h, VIDEO_G=%h, VIDEO_R=%h",
                         expected_VIDEO_B, expected_VIDEO_G, expected_VIDEO_R);
                $display("  Got:      VIDEO_B=%h, VIDEO_G=%h, VIDEO_R=%h",
                         VIDEO_B, VIDEO_G, VIDEO_R);
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
        $dumpvars(0,CLK_6MB, PC, SHADOW, nBNKB, VIDEO_B, VIDEO_G, VIDEO_R);
    end

endmodule
