`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [1:0] state;
    wire green;
    wire red;
    wire yellow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .state(state),
        .green(green),
        .red(red),
        .yellow(yellow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            state = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing Red light (State 00)", test_num);
            reset_dut();
            state = 2'b00;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Red-Yellow light (State 01)", test_num);
            reset_dut();
            state = 2'b01;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Green light (State 10)", test_num);
            reset_dut();
            state = 2'b10;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Yellow light (State 11)", test_num);
            reset_dut();
            state = 2'b11;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Reset Active behavior", test_num);
            reset = 0;
            state = 2'b10;
            @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;


            if (red === 1'b1 && green === 1'b0 && yellow === 1'b0) begin
                $display("PASS: Reset forced Red state");
                pass_count = pass_count + 1;
            end else if (red === 1'b0 && green === 1'b0 && yellow === 1'b0) begin
                $display("PASS: Reset cleared all lights");
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: Unexpected light combination during reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_green;
        input expected_red;
        input expected_yellow;
        begin
            if (expected_green === (expected_green ^ green ^ expected_green) &&
                expected_red === (expected_red ^ red ^ expected_red) &&
                expected_yellow === (expected_yellow ^ yellow ^ expected_yellow)) begin
                $display("PASS");
                $display("  Outputs: green=%b, red=%b, yellow=%b",
                         green, red, yellow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: green=%b, red=%b, yellow=%b",
                         expected_green, expected_red, expected_yellow);
                $display("  Got:      green=%b, red=%b, yellow=%b",
                         green, red, yellow);
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
        $dumpvars(0,clk, reset, state, green, red, yellow);
    end

endmodule
