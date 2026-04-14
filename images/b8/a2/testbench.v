`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (sequential circuit)
    reg add_sub;
    reg clk;
    reg [15:0] operand1;
    reg [15:0] operand2;
    reg reset;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .add_sub(add_sub),
        .clk(clk),
        .operand1(operand1),
        .operand2(operand2),
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
            add_sub = 0;
            operand1 = 0;
            operand2 = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Simple Addition (500 + 250)", test_num);
            add_sub = 0;
            operand1 = 16'd500;
            operand2 = 16'd250;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd750);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Simple Subtraction (1000 - 400)", test_num);
            add_sub = 1;
            operand1 = 16'd1000;
            operand2 = 16'd400;
            @(posedge clk);
            #1 #1;
 check_outputs(16'd600);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Addition Wrap Around (0xFFFF + 1)", test_num);
            add_sub = 0;
            operand1 = 16'hFFFF;
            operand2 = 16'h0001;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Subtraction Negative (10 - 20)", test_num);
            add_sub = 1;
            operand1 = 16'd10;
            operand2 = 16'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFF6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Subtraction Result Zero (0xABCD - 0xABCD)", test_num);
            add_sub = 1;
            operand1 = 16'hABCD;
            operand2 = 16'hABCD;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Large Value Addition (0x8000 + 0x8000)", test_num);
            add_sub = 0;
            operand1 = 16'h8000;
            operand2 = 16'h8000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Subtraction from Zero (0 - 1)", test_num);
            add_sub = 1;
            operand1 = 16'h0000;
            operand2 = 16'h0001;
            @(posedge clk);
            #1 #1;
 check_outputs(16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
        $dumpvars(0,add_sub, clk, operand1, operand2, reset, result);
    end

endmodule
