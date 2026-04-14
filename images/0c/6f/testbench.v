`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction_in;
    reg reset;
    wire [7:0] instruction_out;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .instruction_out(instruction_out),
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
            instruction_in = 8'h00;
            @(posedge clk);
            #2;
            reset = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Add 1 + 2", test_num);
            reset_dut();
            instruction_in = 8'h12;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h12, 8'h03);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Add 5 + 0", test_num);
            reset_dut();
            instruction_in = 8'h50;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h50, 8'h05);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Add 10 + 5 (0xA + 0x5)", test_num);
            reset_dut();
            instruction_in = 8'hA5;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5, 8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max values 15 + 15", test_num);
            reset_dut();
            instruction_in = 8'hFF;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'h1E);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero addition 0 + 0", test_num);
            reset_dut();
            instruction_in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_instruction_out;
        input [7:0] expected_result;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, result=%h",
                         instruction_out, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, result=%h",
                         expected_instruction_out, expected_result);
                $display("  Got:      instruction_out=%h, result=%h",
                         instruction_out, result);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out, result);
    end

endmodule
