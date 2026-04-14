`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] control;
    reg [31:0] data_input1;
    reg [31:0] data_input2;
    wire [31:0] data_output;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control(control),
        .data_input1(data_input1),
        .data_input2(data_input2),
        .data_output(data_output),
        .zero(zero)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            control = 4'b0000;
            data_input1 = 32'd0;
            data_input2 = 32'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Test 001: Addition (10 + 20)");
            test_num = 1;
            control = OP_ADD;
            data_input1 = 32'd10;
            data_input2 = 32'd20;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd30, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Test 002: Subtraction (50 - 15)");
            test_num = 2;
            control = OP_SUB;
            data_input1 = 32'd50;
            data_input2 = 32'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd35, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Test 003: Subtraction (100 - 100) -> Zero Flag");
            test_num = 3;
            control = OP_SUB;
            data_input1 = 32'd100;
            data_input2 = 32'd100;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Test 004: Bitwise AND (0xFFFF0000 & 0xAAAA5555)");
            test_num = 4;
            control = OP_AND;
            data_input1 = 32'hFFFF0000;
            data_input2 = 32'hAAAA5555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA0000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Test 005: Bitwise OR (0xF0F0F0F0 | 0x0F0F0F0F)");
            test_num = 5;
            control = OP_OR;
            data_input1 = 32'hF0F0F0F0;
            data_input2 = 32'h0F0F0F0F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Test 006: SLT (5 < 10)");
            test_num = 6;
            control = OP_SLT;
            data_input1 = 32'd5;
            data_input2 = 32'd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Test 007: SLT (Signed: 1 < -1)");
            test_num = 7;
            control = OP_SLT;
            data_input1 = 32'sd1;
            data_input2 = -32'sd1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            $display("Test 008: Bitwise NOR (0x00000000 NOR 0x00000000)");
            test_num = 8;
            control = OP_NOR;
            data_input1 = 32'h0;
            data_input2 = 32'h0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            $display("Test 009: Signed Addition (-5 + -10)");
            test_num = 9;
            control = OP_ADD;
            data_input1 = -32'sd5;
            data_input2 = -32'sd10;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-32'sd15, 1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            $display("Test 010: Default (Undefined Opcode 4'b1111)");
            test_num = 10;
            control = 4'b1111;
            data_input1 = 32'h12345678;
            data_input2 = 32'h87654321;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'd0, 1'b0);
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
        input [31:0] expected_data_output;
        input expected_zero;
        begin
            if (expected_data_output === (expected_data_output ^ data_output ^ expected_data_output) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: data_output=%h, zero=%b",
                         data_output, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_output=%h, zero=%b",
                         expected_data_output, expected_zero);
                $display("  Got:      data_output=%h, zero=%b",
                         data_output, zero);
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
        $dumpvars(0,clk, control, data_input1, data_input2, data_output, zero);
    end

endmodule
