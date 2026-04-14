`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg enable;
    reg load;
    reg [15:0] load_value;
    reg reset;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dir(dir),
        .enable(enable),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            load = 0;
            dir = 0;
            load_value = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            load = 1;
            load_value = 16'hA5A5;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            load = 1;
            load_value = 16'h0001;
            @(negedge clk);

            load = 0;
            dir = 0;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(16'h0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift", test_num);
            reset_dut();

            @(negedge clk);
            enable = 1;
            load = 1;
            load_value = 16'h8000;
            @(negedge clk);

            load = 0;
            dir = 1;
            repeat(4) @(negedge clk);

            #1;


            check_outputs(16'h0800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable/Disable Control", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            load = 1;
            load_value = 16'h55AA;
            @(negedge clk);
            load = 0;
            enable = 0;
            dir = 1;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Parallel Load Priority", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1;
            load = 1;
            dir = 0;
            load_value = 16'hF0F0;
            @(negedge clk);

            #1;


            check_outputs(16'hF0F0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequence Load-Left-Right", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1; load = 1; load_value = 16'h00FF;
            @(negedge clk);
            load = 0; dir = 0;
            @(negedge clk);
            @(negedge clk);
            dir = 1;
            @(negedge clk);
            #1;

            check_outputs(16'h01FE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Async Reset During Operation", test_num);
            reset_dut();
            @(negedge clk);
            enable = 1; load = 1; load_value = 16'hFFFF;
            @(negedge clk);
            load = 0;
            #3;
            reset = 1;
            #2;
            #1;

            check_outputs(16'h0000);
            reset = 0;
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
        testcase008();
        
        
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, dir, enable, load, load_value, reset, q);
    end

endmodule
