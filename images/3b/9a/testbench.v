`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    wire [1:0] stage_id;
    wire [4:0] stage_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .stage_id(stage_id),
        .stage_output(stage_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instruction = 5'b0;

            repeat (5) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction 5'h0A", test_num);
            reset_dut();


            instruction = 5'h0A;
            @(posedge clk);


            instruction = 5'h00;
            @(posedge clk);


            @(posedge clk);

            #2;
            #1;

            check_outputs(2'd3, 5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction 5'h15", test_num);
            reset_dut();


            instruction = 5'h15;
            @(posedge clk);


            instruction = 5'h00;
            repeat (2) @(posedge clk);

            #2;
            #1;

            check_outputs(2'd3, 5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction 5'h1F (Max Value)", test_num);
            reset_dut();

            instruction = 5'h1F;
            @(posedge clk);

            instruction = 5'h00;
            repeat (2) @(posedge clk);

            #2;
            #1;

            check_outputs(2'd3, 5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Instruction 5'h00", test_num);
            reset_dut();


            instruction = 5'h01;
            @(posedge clk);

            instruction = 5'h00;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #2;
            #1;

            check_outputs(2'd3, 5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Instruction 0x11 is in ID stage (Stage 2)", test_num);
            reset_dut();

            instruction = 5'h11;
            @(posedge clk);
            instruction = 5'h00;
            @(posedge clk);

            #2;
            #1;

            check_outputs(2'd2, 5'h11);
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
        input [1:0] expected_stage_id;
        input [4:0] expected_stage_output;
        begin
            if (expected_stage_id === (expected_stage_id ^ stage_id ^ expected_stage_id) &&
                expected_stage_output === (expected_stage_output ^ stage_output ^ expected_stage_output)) begin
                $display("PASS");
                $display("  Outputs: stage_id=%h, stage_output=%h",
                         stage_id, stage_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage_id=%h, stage_output=%h",
                         expected_stage_id, expected_stage_output);
                $display("  Got:      stage_id=%h, stage_output=%h",
                         stage_id, stage_output);
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
        $dumpvars(0,clk, instruction, stage_id, stage_output);
    end

endmodule
