`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ALUop;
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    wire [31:0] hi_data;
    wire [31:0] lo_data;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALUop(ALUop),
        .a(a),
        .b(b),
        .clk(clk),
        .hi_data(hi_data),
        .lo_data(lo_data),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ALUop = OP_MTHI; a = 32'h0; b = 32'h0;
            @(posedge clk);
            ALUop = OP_MTLO; a = 32'h0;
            @(posedge clk);
            ALUop = 4'hF;
            a = 0; b = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ALUop = OP_ADD; a = 32'd100; b = 32'd250;
            #10;
            $display("Test %0d: Addition", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'd350);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ALUop = OP_SUB; a = 32'd500; b = 32'd150;
            #10;
            $display("Test %0d: Subtraction", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'd350);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ALUop = OP_AND; a = 32'hFFFF0000; b = 32'hAAAA5555;
            #10;
            $display("Test %0d: Logical AND", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'hAAAA0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ALUop = OP_XOR; a = 32'hF0F0F0F0; b = 32'h0F0F0F0F;
            #10;
            $display("Test %0d: Logical XOR", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            ALUop = OP_SLL; a = 32'h00000001; b = 32'd8;
            #10;
            $display("Test %0d: Shift Left Logical", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'h00000100);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            ALUop = OP_SRA; a = 32'h80000000; b = 32'd2;
            #10;
            $display("Test %0d: Shift Right Arithmetic", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'hE0000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            ALUop = OP_SLT; a = 32'd10; b = 32'd20;
            #10;
            $display("Test %0d: SLT (True case)", test_num);
            #1;

            check_outputs(32'h0, 32'h0, 32'h1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;

            ALUop = OP_MULT; a = 32'h00010000; b = 32'h00010000;
            @(posedge clk);
            #2;
            $display("Test %0d: Multiplication (HI/LO)", test_num);
            #1;

            check_outputs(32'h1, 32'h0, result);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            ALUop = OP_MTHI; a = 32'hDEADBEEF;
            @(posedge clk);
            #2;
            ALUop = OP_MFHI;
            #10;
            $display("Test %0d: MTHI and MFHI", test_num);
            #1;

            check_outputs(32'hDEADBEEF, 32'h0, 32'hDEADBEEF);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            ALUop = OP_MTLO; a = 32'hBADC0FFE;
            @(posedge clk);
            #2;
            ALUop = OP_MFLO;
            #10;
            $display("Test %0d: MTLO and MFLO", test_num);
            #1;

            check_outputs(32'h0, 32'hBADC0FFE, 32'hBADC0FFE);
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
        input [31:0] expected_hi_data;
        input [31:0] expected_lo_data;
        input [31:0] expected_result;
        begin
            if (expected_hi_data === (expected_hi_data ^ hi_data ^ expected_hi_data) &&
                expected_lo_data === (expected_lo_data ^ lo_data ^ expected_lo_data) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: hi_data=%h, lo_data=%h, result=%h",
                         hi_data, lo_data, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hi_data=%h, lo_data=%h, result=%h",
                         expected_hi_data, expected_lo_data, expected_result);
                $display("  Got:      hi_data=%h, lo_data=%h, result=%h",
                         hi_data, lo_data, result);
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
        $dumpvars(0,ALUop, a, b, clk, hi_data, lo_data, result);
    end

endmodule
