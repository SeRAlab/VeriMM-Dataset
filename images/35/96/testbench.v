`timescale 1ns/1ps

module pipeline_processor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] instruction;
    reg rst;
    reg stall;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pipeline_processor dut (
        .clk(clk),
        .instruction(instruction),
        .rst(rst),
        .stall(stall),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            instruction = 0;
            stall = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic ADD", test_num);
            reset_dut();
            instruction = 4'b0001;
            @(posedge clk);
            #1 instruction = 0;


            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic SUB", test_num);
            reset_dut();
            instruction = 4'b0010;
            @(posedge clk);
            #1 instruction = 0;

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic AND", test_num);
            reset_dut();
            instruction = 4'b0100;
            @(posedge clk);
            #1 instruction = 0;

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h04);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic OR", test_num);
            reset_dut();
            instruction = 4'b1000;
            @(posedge clk);
            #1 instruction = 0;

            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Stall", test_num);
            reset_dut();
            instruction = 4'b0001;
            @(posedge clk);
            #1 instruction = 0;


            repeat(2) @(posedge clk);
            #1 stall = 1;
            repeat(2) @(posedge clk);
            #1 stall = 0;


            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pipeline Throughput", test_num);
            reset_dut();


            instruction = 4'b0001;
            @(posedge clk);
            #1 instruction = 4'b0010;
            @(posedge clk);
            #1 instruction = 4'b1000;
            @(posedge clk);
            #1 instruction = 0;



            repeat(6) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Mid-Pipeline", test_num);
            reset_dut();
            instruction = 4'b0001;
            @(posedge clk);
            #1 instruction = 0;

            repeat(3) @(posedge clk);
            #1 rst = 1;
            @(posedge clk);
            #1 rst = 0;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
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
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, instruction, rst, stall, result);
    end

endmodule
