`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] instruction;
    reg reset;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
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
            instruction = 16'h0000;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test Case 001: Addition Operation (ADD)");



            instruction = 16'h1123;
            @(posedge clk);



            instruction = 16'h0000;
            repeat (4) @(posedge clk);


            #1;
            #1;

            check_outputs(16'h0033);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test Case 002: Subtraction Operation (SUB)");


            instruction = 16'h2456;
            @(posedge clk);

            instruction = 16'h0000;
            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test Case 003: Logical AND Operation");


            instruction = 16'h4789;
            @(posedge clk);

            instruction = 16'h0000;
            repeat (4) @(posedge clk);

            #1;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test Case 004: Pipeline Throughput (Back-to-back instructions)");


            instruction = 16'h1123;
            @(posedge clk);
            instruction = 16'h2456;
            @(posedge clk);
            instruction = 16'h4789;
            @(posedge clk);


            instruction = 16'h0000;
            repeat (4) @(posedge clk);

            #1;

            #1;


            check_outputs(16'h0008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pipeline_processor Testbench");
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
        input [15:0] expected_result;
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
