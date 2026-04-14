`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    reg [1:0] operation_select;
    reg [4:0] shift_amount;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .operation_select(operation_select),
        .shift_amount(shift_amount),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 32'h0;
            b = 32'h0;
            operation_select = 2'b00;
            shift_amount = 5'b0;
            repeat(3) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 32'hF0F0F0F0;
            b = 32'hFFFF0000;
            operation_select = 2'b00;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hF0F00000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 32'hAAAA0000;
            b = 32'h00005555;
            operation_select = 2'b01;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            a = 32'hFFFFFFFF;
            b = 32'h12345678;
            operation_select = 2'b10;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hEDCBA987);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 32'h00000001;
            shift_amount = 5'd8;
            operation_select = 2'b11;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 32'h000000FF;
            shift_amount = 5'd24;
            operation_select = 2'b11;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFF000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 32'h12345678;
            b = 32'h00000000;
            operation_select = 2'b00;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            a = 32'hDEADBEEF;
            b = 32'hDEADBEEF;
            operation_select = 2'b10;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            a = 32'hFFFFFFFF;
            shift_amount = 5'd31;
            operation_select = 2'b11;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, operation_select, shift_amount, result);
    end

endmodule
