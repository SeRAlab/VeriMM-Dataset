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
            instruction = 32'b0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic ADD Instruction", test_num);
            reset_dut();





            instruction = 32'h01_01_0A_14;
            @(posedge clk);
            #1;


            instruction = 32'h0;
            repeat (5) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h0000001E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RAW Hazard Detection (Immediate Dependency)", test_num);
            reset_dut();


            instruction = 32'h01_01_0A_0A;
            @(posedge clk);
            #1;


            instruction = 32'h01_02_01_05;
            @(posedge clk);
            #1;


            instruction = 32'h0;

            repeat (8) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000019);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pipeline Throughput (Multiple Instructions)", test_num);
            reset_dut();


            instruction = 32'h01_01_01_01;
            @(posedge clk); #1;

            instruction = 32'h01_02_02_02;
            @(posedge clk); #1;

            instruction = 32'h01_03_03_03;
            @(posedge clk); #1;

            instruction = 32'h0;
            repeat (6) @(posedge clk);
            #1;


            #1;



            check_outputs(32'h00000006);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Distance-2 RAW Hazard", test_num);
            reset_dut();

            instruction = 32'h01_01_05_05;
            @(posedge clk); #1;
            instruction = 32'h01_04_02_02;
            @(posedge clk); #1;
            instruction = 32'h01_05_01_02;
            @(posedge clk); #1;

            instruction = 32'h0;
            repeat (8) @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0000000C);
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
