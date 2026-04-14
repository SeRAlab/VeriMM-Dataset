`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] input_data;
    reg load;
    reg up_down;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .input_data(input_data),
        .load(load),
        .up_down(up_down),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            input_data = 4'b0000;
            up_down = 0;
            @(negedge clk);
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load value 4'hA", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            input_data = 4'hA;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Up counting 3 times from 0", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 1;
            load = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Down counting from 0 (Underflow)", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 0;
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Up counting from 15 (Overflow)", test_num);
            reset_dut();

            @(negedge clk);
            load = 1;
            input_data = 4'hF;
            @(negedge clk);
            load = 0;
            up_down = 1;
            @(negedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load 8, decrement 4 times", test_num);
            reset_dut();
            @(negedge clk);
            load = 1;
            input_data = 4'h8;
            @(negedge clk);
            load = 0;
            up_down = 0;
            repeat (4) @(negedge clk);
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Load priority over counting", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 1;
            load = 1;
            input_data = 4'h5;
            @(negedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Toggle direction (Up 2, Down 1)", test_num);
            reset_dut();
            @(negedge clk);
            up_down = 1;
            repeat (2) @(negedge clk);
            up_down = 0;
            @(negedge clk);
            #1;

            check_outputs(4'h1);
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, input_data, load, up_down, Q);
    end

endmodule
