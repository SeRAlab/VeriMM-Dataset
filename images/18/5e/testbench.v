`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            instruction = {8'h01, 12'd10, 12'd20};

            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 001: Addition (10 + 20)");
            #1;

            check_outputs(32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            instruction = {8'h02, 12'd100, 12'd45};
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 002: Subtraction (100 - 45)");
            #1;

            check_outputs(32'd55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            instruction = {8'h03, 12'd12, 12'd11};
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 003: Multiplication (12 * 11)");
            #1;

            check_outputs(32'd132);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            instruction = {8'h04, 12'd200, 12'd10};
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 004: Division (200 / 10)");
            #1;

            check_outputs(32'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            instruction = {8'h01, 12'd4000, 12'd4000};
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 005: Large Addition (4000 + 4000)");
            #1;

            check_outputs(32'd8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            instruction = {8'h03, 12'd50, 12'd0};
            repeat (3) @(posedge clk);
            #2;
            $display("Test Case 006: Multiplication by Zero (50 * 0)");
            #1;

            check_outputs(32'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("instruction_pipeline Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, instruction, reset, result);
    end

endmodule
