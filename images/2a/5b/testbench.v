`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] instruction;
    reg rst;
    wire [2:0] current_stage;
    wire [31:0] processed_instruction;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .current_stage(current_stage),
        .processed_instruction(processed_instruction)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Full pipeline traversal to Commit stage", test_num);
            reset_dut();
            instruction = 32'hDEADBEEF;

            repeat (6) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd6, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Check Fetch stage (Stage 0)", test_num);
            reset_dut();
            instruction = 32'h12345678;
            #2;
            #1;

            check_outputs(3'd0, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Check Execute stage (Stage 2)", test_num);
            reset_dut();
            instruction = 32'hAABBCCDD;
            repeat (2) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2, 32'hAABBCCDD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Check Memory Access stage (Stage 3)", test_num);
            reset_dut();
            instruction = 32'h11223344;
            repeat (3) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3, 32'h11223344);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Check Hazard Detection stage (Stage 5)", test_num);
            reset_dut();
            instruction = 32'hFFFFFFFF;
            repeat (5) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd5, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Check Write Back stage (Stage 4) with zero data", test_num);
            reset_dut();
            instruction = 32'h00000000;
            repeat (4) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd4, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipelined_processor Testbench");
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
        input [2:0] expected_current_stage;
        input [31:0] expected_processed_instruction;
        begin
            if (expected_current_stage === (expected_current_stage ^ current_stage ^ expected_current_stage) &&
                expected_processed_instruction === (expected_processed_instruction ^ processed_instruction ^ expected_processed_instruction)) begin
                $display("PASS");
                $display("  Outputs: current_stage=%h, processed_instruction=%h",
                         current_stage, processed_instruction);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: current_stage=%h, processed_instruction=%h",
                         expected_current_stage, expected_processed_instruction);
                $display("  Got:      current_stage=%h, processed_instruction=%h",
                         current_stage, processed_instruction);
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
        $dumpvars(0,clk, instruction, rst, current_stage, processed_instruction);
    end

endmodule
