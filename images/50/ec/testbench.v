`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            operand_a = 0;
            operand_b = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition (0 + 0)", test_num);
            reset_dut();
            operand_a = 8'h00;
            operand_b = 8'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (10 + 20)", test_num);
            reset_dut();
            operand_a = 8'd10;
            operand_b = 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 7-bit Result (64 + 63 = 127)", test_num);
            reset_dut();
            operand_a = 8'd64;
            operand_b = 8'd63;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 7-bit Overflow (64 + 64 = 128 -> 0)", test_num);
            reset_dut();
            operand_a = 8'd64;
            operand_b = 8'd64;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 8-bit Overflow (255 + 1 = 256 -> 0)", test_num);
            reset_dut();
            operand_a = 8'd255;
            operand_b = 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 8-bit Inputs (255 + 255 = 510 -> 126)", test_num);
            reset_dut();
            operand_a = 8'hFF;
            operand_b = 8'hFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'h7E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Truncation (100 + 50 = 150 -> 22)", test_num);
            reset_dut();
            operand_a = 8'd100;
            operand_b = 8'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(7'd22);
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
        input [6:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, operand_a, operand_b, out);
    end

endmodule
