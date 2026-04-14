`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction;
    wire [2:0] stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction(instruction),
        .stage(stage)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            instruction = 5'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Fetch stage transition", test_num);
            reset_dut();
            instruction = 5'b10101;
            @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Decode stage transition", test_num);
            reset_dut();
            instruction = 5'b01100;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Execute stage transition", test_num);
            reset_dut();
            instruction = 5'b11111;
            repeat(3) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing Pipeline wrap-around (4 cycles)", test_num);
            reset_dut();
            instruction = 5'b00001;
            repeat(4) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Testing progression with instruction 0x00", test_num);
            reset_dut();
            instruction = 5'b00000;
            repeat(2) @(posedge clk);
            #2;
            #1;

            check_outputs(3'd2);
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
        $dumpvars(0,clk, instruction, stage);
    end

endmodule
