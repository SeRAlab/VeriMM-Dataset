`timescale 1ns/1ps

module pipelined_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] instruction;
    reg reset;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipelined_processor dut (
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
            instruction = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Basic Instruction Flow", test_num);
            reset_dut();


            instruction = 8'hA1;
            @(posedge clk);
            instruction = 8'h00;


            repeat(8) @(posedge clk);

            #1;


            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: RAW Hazard Detection", test_num);
            reset_dut();

            instruction = 8'hB1;
            @(posedge clk);
            instruction = 8'hB2;
            @(posedge clk);
            instruction = 8'h00;


            repeat(12) @(posedge clk);

            #1;


            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: WAW Hazard Handling", test_num);
            reset_dut();

            instruction = 8'hC1;
            @(posedge clk);
            instruction = 8'hC2;
            @(posedge clk);
            instruction = 8'h00;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(8'hC2);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Pipeline Flush", test_num);
            reset_dut();

            instruction = 8'hD1;
            @(posedge clk);
            instruction = 8'hFF;
            @(posedge clk);
            instruction = 8'hD2;
            @(posedge clk);
            instruction = 8'hD3;
            @(posedge clk);
            instruction = 8'h00;

            repeat(12) @(posedge clk);



            #1;




            check_outputs(8'hD3);
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
        input [7:0] expected_result;
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
