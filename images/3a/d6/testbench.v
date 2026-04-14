`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] instruction_in;
    reg rst;
    wire [4:0] result_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction_in(instruction_in),
        .rst(rst),
        .result_out(result_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction_in = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Single Instruction", test_num);
            reset_dut();


            @(posedge clk);
            #1 instruction_in = 5'h0A;


            @(posedge clk);
            #1 instruction_in = 5'h00;


            repeat(4) @(posedge clk);


            @(posedge clk);
            #1;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Continuous Pipeline Stream", test_num);
            reset_dut();

            @(posedge clk);
            #1 instruction_in = 5'h01;
            @(posedge clk);
            #1 instruction_in = 5'h02;
            @(posedge clk);
            #1 instruction_in = 5'h03;
            @(posedge clk);
            #1 instruction_in = 5'h04;
            @(posedge clk);
            #1 instruction_in = 5'h1F;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: NOP Handling", test_num);
            reset_dut();


            @(posedge clk);
            #1 instruction_in = 5'h15;
            @(posedge clk);
            #1 instruction_in = 5'h00;


            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Max Value Processing", test_num);
            reset_dut();

            @(posedge clk);
            #1 instruction_in = 5'h1F;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset During Operation", test_num);
            reset_dut();

            @(posedge clk);
            #1 instruction_in = 5'h0E;


            repeat(3) @(posedge clk);


            #1 rst = 1;
            repeat(2) @(posedge clk);
            #1 rst = 0;


            repeat(1) @(posedge clk);
            #1;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_result_out;
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
        $dumpvars(0,clk, instruction_in, rst, result_out);
    end

endmodule
