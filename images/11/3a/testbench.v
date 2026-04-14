`timescale 1ns/1ps

module instruction_pipeline_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg rst;
    wire [4:0] instruction_out;
    wire [1:0] stage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    instruction_pipeline dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
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
            rst = 1;
            instruction_in = 5'b0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Instruction Flow (3 Stages)", test_num);
            reset_dut();


            instruction_in = 5'h0A;
            @(posedge clk); #1;


            instruction_in = 5'h00;
            @(posedge clk); #1;


            instruction_in = 5'h00;
            @(posedge clk); #1;


            #1;



            check_outputs(5'h0A, 2'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous Pipeline Stream", test_num);
            reset_dut();


            instruction_in = 5'h01; @(posedge clk); #1;
            instruction_in = 5'h02; @(posedge clk); #1;
            instruction_in = 5'h03; @(posedge clk); #1;


            #1;



            check_outputs(5'h01, 2'd2);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Progression Check", test_num);
            reset_dut();


            instruction_in = 5'h10; @(posedge clk); #1;
            instruction_in = 5'h11; @(posedge clk); #1;
            instruction_in = 5'h12; @(posedge clk); #1;
            instruction_in = 5'h13; @(posedge clk); #1;


            #1;



            check_outputs(5'h11, 2'd2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();



            #1;




            check_outputs(5'h00, 2'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Instruction Value (0x1F)", test_num);
            reset_dut();

            instruction_in = 5'h1F; @(posedge clk); #1;
            instruction_in = 5'h00; @(posedge clk); #1;
            instruction_in = 5'h00; @(posedge clk); #1;

            #1;


            check_outputs(5'h1F, 2'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline Recovery After Mid-Flow Reset", test_num);
            reset_dut();


            instruction_in = 5'h05; @(posedge clk); #1;
            instruction_in = 5'h06; @(posedge clk); #1;


            reset_dut();


            #1;



            check_outputs(5'h00, 2'd0);
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
        input [4:0] expected_instruction_out;
        input [1:0] expected_stage;
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
        $dumpvars(0,clk, instruction_in, rst, instruction_out, stage);
    end

endmodule
