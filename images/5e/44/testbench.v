`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg direction;
    reg ena;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .direction(direction),
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
            @(posedge clk);
            load = 1;
            data = 8'h00;
            ena = 0;
            direction = 0;
            @(posedge clk);
            load = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Synchronous Load", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            data = 8'hA5;
            @(posedge clk);
            load = 0;
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right", test_num);
            reset_dut();

            load = 1;
            data = 8'h80;
            @(posedge clk);

            load = 0;
            ena = 1;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Left", test_num);
            reset_dut();

            load = 1;
            data = 8'h01;
            @(posedge clk);

            load = 0;
            ena = 1;
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable priority (ena=0)", test_num);
            reset_dut();

            load = 1;
            data = 8'hFF;
            @(posedge clk);

            load = 0;
            ena = 0;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load priority over enable", test_num);
            reset_dut();

            load = 1;
            data = 8'hAA;
            @(posedge clk);

            load = 1;
            data = 8'h55;
            ena = 1;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Shifts Right", test_num);
            reset_dut();
            load = 1;
            data = 8'hF0;
            @(posedge clk);
            load = 0;
            ena = 1;
            direction = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple Shifts Left", test_num);
            reset_dut();
            load = 1;
            data = 8'h0F;
            @(posedge clk);
            load = 0;
            ena = 1;
            direction = 0;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Shift Right until empty", test_num);
            reset_dut();
            load = 1;
            data = 8'hFF;
            @(posedge clk);
            load = 0;
            ena = 1;
            direction = 1;
            repeat (8) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Direction Switching", test_num);
            reset_dut();
            load = 1;
            data = 8'h10;
            @(posedge clk);
            load = 0;
            ena = 1;

            direction = 0;
            @(posedge clk);

            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h10);
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
        testcase009();
        
        
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, data, direction, ena, load, q);
    end

endmodule
