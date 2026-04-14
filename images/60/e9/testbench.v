`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg direction;
    reg load;
    reg rst;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .direction(direction),
        .load(load),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            direction = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset and Load 1011", test_num);
            reset_dut();
            data_in = 4'b1011;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 1001 then Left Shift Once", test_num);
            reset_dut();
            data_in = 4'b1001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 1001 then Right Shift Once", test_num);
            reset_dut();
            data_in = 4'b1001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 0001 then Left Shift Twice", test_num);
            reset_dut();
            data_in = 4'b0001;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Load 1100 then Right Shift 3 times", test_num);
            reset_dut();
            data_in = 4'b1100;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            direction = 1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b1001);
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, direction, load, rst, data_out);
    end

endmodule
