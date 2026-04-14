`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [99:0] q;
    wire [99:0] q_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q),
        .q_out(q_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 1'b1;
            data = 100'b0;
            ena = 2'b00;
            @(posedge clk);
            #1;
            load = 1'b0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data = 100'h5555555555555555555555555;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            #1;

            check_outputs(100'h5555555555555555555555555, 100'h5555555555555555555555555);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data = 100'h1;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(100'h2, 100'h2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            data = 100'h2;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(100'h1, 100'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data = (100'b1 << 99);
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(100'h1, 100'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            data = 100'h1;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs((100'b1 << 99), (100'b1 << 99));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 100'hF;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b01;
            repeat(3) @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(100'h78, 100'h78);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 100'hABCDE;
            load = 1'b1;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b00;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(100'hABCDE, 100'hABCDE);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 100'h1;
            load = 1'b1;
            @(posedge clk);
            #1;

            data = 100'hFEDCBA;
            load = 1'b1;
            ena = 2'b01;
            @(posedge clk);
            #1;
            load = 1'b0;
            ena = 2'b00;

            #1;


            check_outputs(100'hFEDCBA, 100'hFEDCBA);
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
        input [99:0] expected_q_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_q_out === (expected_q_out ^ q_out ^ expected_q_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, q_out=%h",
                         q, q_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, q_out=%h",
                         expected_q, expected_q_out);
                $display("  Got:      q=%h, q_out=%h",
                         q, q_out);
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
        $dumpvars(0,clk, data, ena, load, q, q_out);
    end

endmodule
