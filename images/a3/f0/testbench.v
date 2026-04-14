`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg input1;
    reg input2;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input1(input1),
        .input2(input2),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            input1 = 0;
            input2 = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking Reset/Initial State (STATE_A)", test_num);
            reset_dut();

            #1;


            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition A -> B (input1=1)", test_num);
            reset_dut();
            input1 = 1;
            input2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition A -> B -> C", test_num);
            reset_dut();

            input1 = 1; input2 = 0;
            @(posedge clk);
            #1;

            input1 = 0; input2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition A -> B -> C -> D", test_num);
            reset_dut();

            input1 = 1; input2 = 0;
            @(posedge clk);
            #1;

            input1 = 0; input2 = 1;
            @(posedge clk);
            #1;

            input1 = 1; input2 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Full Cycle A -> B -> C -> D -> A", test_num);
            reset_dut();

            input1 = 1; input2 = 0; @(posedge clk); #1;
            input1 = 0; input2 = 1; @(posedge clk); #1;
            input1 = 1; input2 = 1; @(posedge clk); #1;
            input1 = 1; input2 = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Test State Hold (inputs=0)", test_num);
            reset_dut();
            input1 = 1; input2 = 0; @(posedge clk); #1;
            input1 = 0; input2 = 0; @(posedge clk); #1;
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, input1, input2, out);
    end

endmodule
