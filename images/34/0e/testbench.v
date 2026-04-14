`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction_in;
    reg reset;
    wire [3:0] instruction_out;
    wire [2:0] stage;

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
        .stage(stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("--- Resetting DUT ---");
            reset = 1;
            instruction_in = 4'h0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Single Instruction (0xA)");
            reset_dut();


            instruction_in = 4'hA;
            @(posedge clk);
            #1;


            instruction_in = 4'h0;
            repeat (3) @(posedge clk);
            #1;



            test_num = 1;
            #1;

            check_outputs(4'hA, 3'd5);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Continuous Pipeline Stream");
            reset_dut();


            instruction_in = 4'h1; @(posedge clk);
            instruction_in = 4'h2; @(posedge clk);
            instruction_in = 4'h3; @(posedge clk);
            instruction_in = 4'h4; @(posedge clk);
            instruction_in = 4'h5; @(posedge clk);


            test_num = 2;
            $display("Checking first instruction in stream...");
            #1;

            check_outputs(4'h1, 3'd5);


            repeat (4) @(posedge clk);
            #1;
            $display("Checking last instruction in stream...");
            #1;

            check_outputs(4'h5, 3'd5);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Reset Mid-Operation");
            reset_dut();


            instruction_in = 4'hF;
            @(posedge clk);
            instruction_in = 4'h0;
            repeat (2) @(posedge clk);


            reset = 1;
            @(posedge clk);
            reset = 0;


            repeat (5) @(posedge clk);
            #1;

            test_num = 3;

            #1;


            check_outputs(4'h0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Zero Instruction (NOP)");
            reset_dut();

            instruction_in = 4'h0;
            repeat (5) @(posedge clk);
            #1;

            test_num = 4;
            #1;

            check_outputs(4'h0, 3'd5);
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
        input [3:0] expected_instruction_out;
        input [2:0] expected_stage;
        begin
            if (expected_instruction_out === (expected_instruction_out ^ instruction_out ^ expected_instruction_out) &&
                expected_stage === (expected_stage ^ stage ^ expected_stage)) begin
                $display("PASS");
                $display("  Outputs: instruction_out=%h, stage=%h",
                         instruction_out, stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: instruction_out=%h, stage=%h",
                         expected_instruction_out, expected_stage);
                $display("  Got:      instruction_out=%h, stage=%h",
                         instruction_out, stage);
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
        $dumpvars(0,clk, instruction_in, reset, instruction_out, stage);
    end

endmodule
