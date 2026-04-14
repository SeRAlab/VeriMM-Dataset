`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add;
    reg clk;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg rst;
    wire done;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .rst(rst),
        .done(done),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            add = 0;
            operand_a = 0;
            operand_b = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'd15;
            operand_b = 8'd25;
            add = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'd40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'd50;
            operand_b = 8'd20;
            add = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'hFF;
            operand_b = 8'h05;
            add = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'h04);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'd10;
            operand_b = 8'd20;
            add = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'd128;
            operand_b = 8'd128;
            add = 1'b0;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            operand_a = 8'hFF;
            operand_b = 8'hFF;
            add = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;


            operand_a = 8'd55;
            operand_b = 8'd45;
            add = 1'b1;
            rst = 1'b1;
            @(posedge clk);
            #2 #1;
 check_outputs(1'b0, 8'b0);
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
        input expected_done;
        input [7:0] expected_result;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: done=%b, result=%h",
                         done, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, result=%h",
                         expected_done, expected_result);
                $display("  Got:      done=%b, result=%h",
                         done, result);
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
        $dumpvars(0,add, clk, operand_a, operand_b, rst, done, result);
    end

endmodule
