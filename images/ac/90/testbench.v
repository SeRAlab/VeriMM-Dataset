`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] alu_op;
    reg clk;
    reg [5:0] func_op;
    wire [3:0] alu_control_sig;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .alu_op(alu_op),
        .clk(clk),
        .func_op(func_op),
        .alu_control_sig(alu_control_sig)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            alu_op = 2'b00;
            func_op = 6'b000000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 001: ALU_OP 00 (Add for LW/SW)");
            alu_op = 2'b00;
            func_op = 6'b111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 002: ALU_OP 01 (Sub for BEQ)");
            alu_op = 2'b01;
            func_op = 6'b111111;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 003: R-type ADD");
            alu_op = 2'b10;
            func_op = 6'b100000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 004: R-type SUB");
            alu_op = 2'b10;
            func_op = 6'b100010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 005: R-type AND");
            alu_op = 2'b10;
            func_op = 6'b100100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 006: R-type OR");
            alu_op = 2'b10;
            func_op = 6'b100101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Test Case 007: R-type SLT");
            alu_op = 2'b10;
            func_op = 6'b101010;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'b0111);
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
        input [3:0] expected_alu_control_sig;
        begin
            if (expected_alu_control_sig === (expected_alu_control_sig ^ alu_control_sig ^ expected_alu_control_sig)) begin
                $display("PASS");
                $display("  Outputs: alu_control_sig=%h",
                         alu_control_sig);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alu_control_sig=%h",
                         expected_alu_control_sig);
                $display("  Got:      alu_control_sig=%h",
                         alu_control_sig);
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
        $dumpvars(0,alu_op, clk, func_op, alu_control_sig);
    end

endmodule
