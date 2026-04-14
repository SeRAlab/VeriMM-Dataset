`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] ALUOP;
    reg [31:0] In1;
    reg [31:0] In2;
    reg clk;
    reg [4:0] shamt;
    wire [31:0] OUT;
    wire ZeroFlag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUOP(ALUOP),
        .In1(In1),
        .In2(In2),
        .clk(clk),
        .shamt(shamt),
        .OUT(OUT),
        .ZeroFlag(ZeroFlag)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALUOP = 3'b000;
            In1 = 32'h0;
            In2 = 32'h0;
            shamt = 5'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Addition (In1=10, In2=25)");
            ALUOP = 3'b000;
            In1 = 32'd10;
            In2 = 32'd25;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd35, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Subtraction (In1=100, In2=40)");
            ALUOP = 3'b001;
            In1 = 32'd100;
            In2 = 32'd40;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd60, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Bitwise AND");
            ALUOP = 3'b010;
            In1 = 32'hAAAA_FFFF;
            In2 = 32'h5555_FFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Bitwise OR");
            ALUOP = 3'b011;
            In1 = 32'h1234_0000;
            In2 = 32'h0000_5678;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1234_5678, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Left Shift (1 << 4)");
            ALUOP = 3'b100;
            In1 = 32'h0000_0001;
            shamt = 5'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0000_0010, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Right Shift (64 >> 3)");
            ALUOP = 3'b101;
            In1 = 32'd64;
            shamt = 5'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd8, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Comparison (5 < 10)");
            ALUOP = 3'b110;
            In1 = 32'd5;
            In2 = 32'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Testcase 008: Comparison (20 < 10)");
            ALUOP = 3'b110;
            In1 = 32'd20;
            In2 = 32'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h0, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Testcase 009: ZeroFlag Equality Check");
            ALUOP = 3'b000;
            In1 = 32'hFFFF_EEEE;
            In2 = 32'hFFFF_EEEE;
            @(posedge clk);
            #2;

            if (ZeroFlag === 1'b1) begin
                 $display("PASS: ZeroFlag correctly set for equality");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: ZeroFlag not set for equality");
                 fail_count = fail_count + 1;
            end
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
        input [31:0] expected_OUT;
        input expected_ZeroFlag;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT) &&
                expected_ZeroFlag === (expected_ZeroFlag ^ ZeroFlag ^ expected_ZeroFlag)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h, ZeroFlag=%b",
                         OUT, ZeroFlag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h, ZeroFlag=%b",
                         expected_OUT, expected_ZeroFlag);
                $display("  Got:      OUT=%h, ZeroFlag=%b",
                         OUT, ZeroFlag);
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
        $dumpvars(0,ALUOP, In1, In2, clk, shamt, OUT, ZeroFlag);
    end

endmodule
