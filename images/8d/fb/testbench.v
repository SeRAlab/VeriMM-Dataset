`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] op;
    reg [31:0] op1;
    reg [31:0] op2;
    wire [31:0] alu_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .op(op),
        .op1(op1),
        .op2(op2),
        .alu_out(alu_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        op1 = 0;
        op2 = 0;
        op = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        op1 = 32'd100;
        op2 = 32'd250;
        op  = 5'd0;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Addition (100 + 250)", test_num);
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        op1 = 32'd500;
        op2 = 32'd150;
        op  = 5'd1;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Subtraction (500 - 150)", test_num);
        #1;

        check_outputs(32'd350);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        op1 = 32'hFFFF0000;
        op2 = 32'hAAAA5555;
        op  = 5'd2;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Bitwise AND (0xFFFF0000 & 0xAAAA5555)", test_num);
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        op1 = 32'hF0F0F0F0;
        op2 = 32'h0F0F0F0F;
        op  = 5'd3;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Bitwise OR (0xF0F0F0F0 | 0x0F0F0F0F)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        op1 = 32'h12345678;
        op2 = 32'h12345678;
        op  = 5'd4;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Bitwise XOR (0x12345678 ^ 0x12345678)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        op1 = 32'h00000001;
        op2 = 32'd8;
        op  = 5'd5;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Shift Left (1 << 8)", test_num);
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        op1 = 32'h00000100;
        op2 = 32'd4;
        op  = 5'd6;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Shift Right (0x100 >> 4)", test_num);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        op1 = 32'hFFFFFFFF;
        op2 = 32'hFFFFFFFF;
        op  = 5'd31;
        @(posedge clk);
        #2;
        $display("Testcase %0d: Undefined Operation (expect 0)", test_num);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_alu_out;
        begin
            if (expected_alu_out === (expected_alu_out ^ alu_out ^ expected_alu_out)) begin
                $display("PASS");
                $display("  Outputs: alu_out=%h",
                         alu_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_out=%h",
                         expected_alu_out);
                $display("  Got:      alu_out=%h",
                         alu_out);
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
        $dumpvars(0,clk, op, op1, op2, alu_out);
    end

endmodule
