`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [15:0] C;
    reg [15:0] D;
    reg [15:0] E;
    reg [15:0] F;
    reg [15:0] G;
    reg [15:0] H;
    reg [15:0] I;
    reg clk;
    wire [15:0] checksum_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .H(H),
        .I(I),
        .clk(clk),
        .checksum_reg(checksum_reg)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; I = 0;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: All ones...");
            A = 16'd1; B = 16'd1; C = 16'd1; D = 16'd1;
            E = 16'd1; F = 16'd1; G = 16'd1; H = 16'd1;
            I = 16'd1;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'd9);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Powers of 2...");
            A = 16'h0001; B = 16'h0002; C = 16'h0004; D = 16'h0008;
            E = 16'h0010; F = 16'h0020; G = 16'h0040; H = 16'h0080;
            I = 16'h0100;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h01FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Large values (Overflow)...");

            A = 16'd10000; B = 16'd10000; C = 16'd10000; D = 16'd10000;
            E = 16'd10000; F = 16'd10000; G = 16'd10000; H = 16'd10000;
            I = 16'd10000;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5F90);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: All Maximum (0xFFFF)...");

            A = 16'hFFFF; B = 16'hFFFF; C = 16'hFFFF; D = 16'hFFFF;
            E = 16'hFFFF; F = 16'hFFFF; G = 16'hFFFF; H = 16'hFFFF;
            I = 16'hFFFF;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFF7);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: All Zeros...");
            A = 0; B = 0; C = 0; D = 0; E = 0; F = 0; G = 0; H = 0; I = 0;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Running Testcase 006: Specific pattern 0x1000 to 0x9000...");


            A = 16'h1000; B = 16'h2000; C = 16'h3000; D = 16'h4000;
            E = 16'h5000; F = 16'h6000; G = 16'h7000; H = 16'h8000;
            I = 16'h9000;
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(16'hD000);
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
        input [15:0] expected_checksum_reg;
        begin
            if (expected_checksum_reg === (expected_checksum_reg ^ checksum_reg ^ expected_checksum_reg)) begin
                $display("PASS");
                $display("  Outputs: checksum_reg=%h",
                         checksum_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_reg=%h",
                         expected_checksum_reg);
                $display("  Got:      checksum_reg=%h",
                         checksum_reg);
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
        $dumpvars(0,A, B, C, D, E, F, G, H, I, clk, checksum_reg);
    end

endmodule
