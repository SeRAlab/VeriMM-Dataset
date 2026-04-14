`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data1;
    reg [99:0] data2;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data1(data1),
        .data2(data2),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1;
            ena = 2'b00;
            data1 = 100'b0;
            data2 = 100'b0;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Load and OR", test_num);
            reset_dut();
            load = 1;
            data1 = 100'hAAAAAAAA;
            data2 = 100'h55555555;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Rotation", test_num);
            reset_dut();

            load = 1;
            data1 = 100'h1;
            data2 = 100'h2;
            @(posedge clk);
            #1;

            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Rotation", test_num);
            reset_dut();

            load = 1;
            data1 = 100'h2;
            data2 = 100'h4;
            @(posedge clk);
            #1;

            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left Wrap Around", test_num);
            reset_dut();

            load = 1;
            data1 = 100'h8000000000000000000000000;
            data2 = 100'h0;
            @(posedge clk);
            #1;

            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right Wrap Around", test_num);
            reset_dut();

            load = 1;
            data1 = 100'h1;
            data2 = 100'h0;
            @(posedge clk);
            #1;

            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h8000000000000000000000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Shifts", test_num);
            reset_dut();
            load = 1;
            data1 = 100'h1;
            data2 = 100'h0;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Rotation (ena=00)", test_num);
            reset_dut();
            load = 1;
            data1 = 100'hABCDE;
            data2 = 100'h0;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'hABCDE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequence of Shifts", test_num);
            reset_dut();
            load = 1;
            data1 = 100'h2;
            data2 = 100'h0;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(100'h2);
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
        input [99:0] expected_q;
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
        $dumpvars(0,clk, data1, data2, ena, load, q);
    end

endmodule
