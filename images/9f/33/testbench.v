`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg RegWrite;
    reg clk;
    reg [2:0] ra1;
    reg [2:0] ra2;
    reg [2:0] wa;
    reg [15:0] wd;
    wire [15:0] rd1;
    wire [15:0] rd2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .RegWrite(RegWrite),
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
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
            RegWrite = 0;
            ra1 = 0;
            ra2 = 0;
            wa = 0;
            wd = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Write to Reg 1 and Read back");
            wa = 3'b001;
            wd = 16'hA5A5;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;
            ra1 = 3'b001;
            ra2 = 3'b001;
            #1;
            #1;

            check_outputs(16'hA5A5, 16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Verify Zero Register behavior");
            wa = 3'b000;
            wd = 16'hFFFF;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;
            ra1 = 3'b000;
            ra2 = 3'b000;
            #1;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Verify RegWrite Enable (Write when Low)");

            wa = 3'b010;
            wd = 16'h1234;
            RegWrite = 1;
            @(posedge clk);
            #1;

            wd = 16'h5678;
            RegWrite = 0;
            @(posedge clk);
            #1;
            ra1 = 3'b010;
            ra2 = 3'b000;
            #1;
            #1;

            check_outputs(16'h1234, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Simultaneous dual-port read");

            wa = 3'b011;
            wd = 16'hCAFE;
            RegWrite = 1;
            @(posedge clk);
            #1;

            wa = 3'b100;
            wd = 16'hBABE;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;
            ra1 = 3'b011;
            ra2 = 3'b100;
            #1;
            #1;

            check_outputs(16'hCAFE, 16'hBABE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Overwriting a register");
            wa = 3'b101;
            wd = 16'h0001;
            RegWrite = 1;
            @(posedge clk);
            #1;
            wd = 16'h8000;
            @(posedge clk);
            #1;
            RegWrite = 0;
            ra1 = 3'b101;
            ra2 = 3'b000;
            #1;
            #1;

            check_outputs(16'h8000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Max address (Reg 7) and Boundary value");
            wa = 3'b111;
            wd = 16'hFFFF;
            RegWrite = 1;
            @(posedge clk);
            #1;
            RegWrite = 0;
            ra1 = 3'b111;
            ra2 = 3'b000;
            #1;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
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
        input [15:0] expected_rd1;
        input [15:0] expected_rd2;
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
        $dumpvars(0,RegWrite, clk, ra1, ra2, wa, wd, rd1, rd2);
    end

endmodule
