`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .start(start),
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
            start = 0;
            a = 0;
            b = 0;
            repeat(2) @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task execute_multiplication;

        input [7:0] val_a;
        input [7:0] val_b;
        reg signed [15:0] expected;
        begin
            a = val_a;
            b = val_b;
            expected = $signed(val_a) * $signed(val_b);

            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;


            wait(done == 1);


            @(posedge clk);
            $display("Test %0d: %d * %d = %d", test_num + 1, $signed(val_a), $signed(val_b), $signed(result));
            #1;

            check_outputs(1, expected);
            test_num = test_num + 1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            execute_multiplication(8'd0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            execute_multiplication(8'd12, 8'd10);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            execute_multiplication(8'd7, -8'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            execute_multiplication(-8'd15, 8'd4);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            execute_multiplication(-8'd8, -8'd5);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            execute_multiplication(8'h7F, 8'h7F);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            execute_multiplication(8'h80, 8'h80);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            execute_multiplication(8'h80, 8'h7F);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            execute_multiplication(-8'd42, 8'd1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            execute_multiplication(8'd127, 8'd0);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            execute_multiplication(8'hFF, 8'd50);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            execute_multiplication(8'd16, 8'd4);
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
        testcase011();
        testcase012();
        
        
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
        input [15:0] expected_result;
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
        $dumpvars(0,a, b, clk, rst, start, done, result);
    end

endmodule
