`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg load;
    reg [9:0] load_value;
    reg reset;
    wire [9:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
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
            @(posedge clk);
            reset = 1;
            load = 0;
            data_in = 0;
            load_value = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 10'h2AA;
            @(posedge clk);
            load = 0;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 10'h3FF;
            @(posedge clk);
            load = 0;
            data_in = 0;
            repeat (2) @(posedge clk);

            #1;


            check_outputs(10'h0FF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            data_in = 1;
            repeat (5) @(posedge clk);

            #1;


            check_outputs(10'h3E0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            data_in = 1;
            repeat (10) @(posedge clk);

            #1;


            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 10'h155;
            @(posedge clk);
            load = 0;
            data_in = 1;
            @(posedge clk);
            data_in = 0;
            @(posedge clk);
            data_in = 1;
            @(posedge clk);
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            load_value = 10'h3FF;
            @(posedge clk);
            reset = 0;
            load = 0;

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase007;

        integer i;
        reg [9:0] pattern;
        begin
            reset_dut();
            pattern = 10'b1100101011;
            for (i = 0; i < 10; i = i + 1) begin
                data_in = pattern[9-i];
                @(posedge clk);
            end

            #1;


            check_outputs(pattern);
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
        input [9:0] expected_q;
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
        $dumpvars(0,clk, data_in, load, load_value, reset, q);
    end

endmodule
