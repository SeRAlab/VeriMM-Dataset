`timescale 1ns/1ps

module pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction_in;
    reg reset;
    wire [31:0] instruction_out;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline dut (
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
            $display("Resetting DUT...");
            reset = 1;
            instruction_in = 32'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Instruction Flow", test_num);
            reset_dut();


            instruction_in = 32'h00230820;
            @(posedge clk);


            instruction_in = 32'h0;
            repeat (4) @(posedge clk);



            #1;
            #1;

            check_outputs(32'h00230820, 32'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pipeline Throughput (No Hazards)", test_num);
            reset_dut();


            @(posedge clk);
            instruction_in = 32'h00451020;
            @(posedge clk);
            instruction_in = 32'h00671820;
            @(posedge clk);
            instruction_in = 32'h00892020;
            @(posedge clk);
            instruction_in = 32'h0;



            repeat (4) @(posedge clk);

            #1;

            #1;


            check_outputs(32'h00892020, 32'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Hazard (RAW)", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h00230820;
            @(posedge clk);
            instruction_in = 32'h00152020;
            @(posedge clk);
            instruction_in = 32'h0;



            repeat (5) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00152020, 32'd35);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load-Use Hazard Stall", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h8C010000;
            @(posedge clk);
            instruction_in = 32'h00121820;
            @(posedge clk);
            instruction_in = 32'h0;



            repeat (6) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h00121820, 32'd110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Operation", test_num);
            reset_dut();

            @(posedge clk);
            instruction_in = 32'h00230820;
            @(posedge clk);
            instruction_in = 32'h00451020;


            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            instruction_in = 32'h0;


            repeat (5) @(posedge clk);

            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline Testbench");
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
        input [31:0] expected_instruction_out;
        input [31:0] expected_result;
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
