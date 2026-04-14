`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction_in;
    reg reset;
    wire [7:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .reset(reset),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            instruction_in = 4'hF;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing ADD operation", test_num);
            instruction_in = 4'b0000;
            @(posedge clk);
            #1 instruction_in = 4'hF;



            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing SUB operation", test_num);
            instruction_in = 4'b0001;
            @(posedge clk);
            #1 instruction_in = 4'hF;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing AND operation", test_num);
            instruction_in = 4'b0010;
            @(posedge clk);
            #1 instruction_in = 4'hF;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing OR operation", test_num);
            instruction_in = 4'b0011;
            @(posedge clk);
            #1 instruction_in = 4'hF;

            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0E);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("\nTestcase %0d: Testing Pipeline Throughput", test_num);


            instruction_in = 4'b0000;
            @(posedge clk); #1;
            instruction_in = 4'b0001;
            @(posedge clk); #1;
            instruction_in = 4'b0010;
            @(posedge clk); #1;
            instruction_in = 4'b0011;
            @(posedge clk); #1;
            instruction_in = 4'hF;



            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0E);
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
        input [7:0] expected_result_out;
        begin
            if (expected_result_out === (expected_result_out ^ result_out ^ expected_result_out)) begin
                $display("PASS");
                $display("  Outputs: result_out=%h",
                         result_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_out=%h",
                         expected_result_out);
                $display("  Got:      result_out=%h",
                         result_out);
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
        $dumpvars(0,clk, instruction_in, reset, result_out);
    end

endmodule
