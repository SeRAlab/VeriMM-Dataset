`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    reg reset;
    wire [2:0] stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .reset(reset),
        .stage(stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction = 5'b0;
            @(posedge clk);
            #1 reset = 0;
            $display("DUT Reset.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Fetch Stage", test_num);
            reset_dut();

            instruction = 5'b10101;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Decode Stage", test_num);
            reset_dut();

            instruction = 5'b11111;
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Execute Stage", test_num);
            reset_dut();

            instruction = 5'b00100;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Mid-Pipeline", test_num);
            reset_dut();

            instruction = 5'b11001;
            @(posedge clk);
            @(posedge clk);


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            instruction = 5'b01010;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Check Flow with Different Instruction", test_num);
            reset_dut();

            instruction = 5'b00001;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'b010);
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
        input [2:0] expected_stage;
        begin
            if (expected_stage === (expected_stage ^ stage ^ expected_stage)) begin
                $display("PASS");
                $display("  Outputs: stage=%h",
                         stage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: stage=%h",
                         expected_stage);
                $display("  Got:      stage=%h",
                         stage);
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
        $dumpvars(0,clk, instruction, reset, stage);
    end

endmodule
