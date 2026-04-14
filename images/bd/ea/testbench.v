`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    wire [2:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 4'b0;
            enable = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            data_in = 4'd0;
            enable = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=1, Data_in=0", test_num);
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            data_in = 4'd5;
            enable = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=1, Data_in=5 (Result 7)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            data_in = 4'd6;
            enable = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=1, Data_in=6 (Result 8, Truncated to 0)", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            data_in = 4'd3;
            enable = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=0, Data_in=3", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            data_in = 4'd9;
            enable = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=0, Data_in=9 (Truncated to 1)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            data_in = 4'd15;
            enable = 1'b1;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Enable=1, Data_in=15 (Result 17, Truncated to 1)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            data_in = 4'd4;
            enable = 1'b1;
            @(posedge clk);
            #1;
            enable = 1'b0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Toggle Enable, Data_in=4", test_num);
            #1;

            check_outputs(3'd4);
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
        input [2:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, enable, data_out);
    end

endmodule
