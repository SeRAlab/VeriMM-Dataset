`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] operand_a;
    reg [7:0] operand_b;
    reg [1:0] operation;
    wire [7:0] result;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .operation(operation),
        .result(result),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            operand_a = 8'h0;
            operand_b = 8'h0;
            operation = 2'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Addition (10 + 20)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'd10;
            operand_b = 8'd20;
            operation = 2'd0;

            @(posedge clk);

            operand_a = 8'h0;
            operand_b = 8'h0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd30, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Subtraction (50 - 15)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'd50;
            operand_b = 8'd15;
            operation = 2'd1;

            @(posedge clk);
            operand_a = 8'h0;
            operand_b = 8'h0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd35, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Addition with Overflow (200 + 100)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'd200;
            operand_b = 8'd100;
            operation = 2'd0;

            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'd44, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Subtraction Underflow (10 - 20)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'd10;
            operand_b = 8'd20;
            operation = 2'd1;

            @(posedge clk);
            @(posedge clk);
            #2;

            #1;


            check_outputs(8'hF6, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Zero Result (0 + 0)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'd0;
            operand_b = 8'd0;
            operation = 2'd0;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Max Value Subtraction (255 - 255)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'hFF;
            operand_b = 8'hFF;
            operation = 2'd1;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Max Value Addition (255 + 1)");
            reset_dut();
            test_num = test_num + 1;

            operand_a = 8'hFF;
            operand_b = 8'h01;
            operation = 2'd0;

            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [7:0] expected_result;
        input expected_valid;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: result=%h, valid=%b",
                         result, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, valid=%b",
                         expected_result, expected_valid);
                $display("  Got:      result=%h, valid=%b",
                         result, valid);
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
        $dumpvars(0,clk, operand_a, operand_b, operation, result, valid);
    end

endmodule
