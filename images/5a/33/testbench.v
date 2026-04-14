`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg parallel_load_enable;
    reg shift_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .parallel_load_enable(parallel_load_enable),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            parallel_load_enable = 1;
            shift_enable = 0;
            data_in = 16'h0000;
            @(posedge clk);
            parallel_load_enable = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test Case %0d: Parallel Load 0xABCD", test_num);
            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'hABCD;
            @(posedge clk);
            parallel_load_enable = 0;
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test Case %0d: Load 0x0001 and Shift Left Once", test_num);

            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'h0001;
            @(posedge clk);
            parallel_load_enable = 0;

            shift_enable = 1;
            @(posedge clk);
            shift_enable = 0;
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test Case %0d: Load 0x00FF and Shift Left 4 times", test_num);

            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'h00FF;
            @(posedge clk);
            parallel_load_enable = 0;

            shift_enable = 1;
            repeat(4) @(posedge clk);
            shift_enable = 0;
            #1;
            #1;

            check_outputs(16'h0FF0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test Case %0d: Hold Value (No Enables)", test_num);

            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'h1234;
            @(posedge clk);
            parallel_load_enable = 0;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test Case %0d: Priority Test (Load and Shift both high)", test_num);
            @(posedge clk);
            parallel_load_enable = 1;
            shift_enable = 1;
            data_in = 16'h55AA;
            @(posedge clk);
            parallel_load_enable = 0;
            shift_enable = 0;
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test Case %0d: Shift MSB out (0x8001 -> 0x0002)", test_num);

            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'h8001;
            @(posedge clk);
            parallel_load_enable = 0;

            shift_enable = 1;
            @(posedge clk);
            shift_enable = 0;
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test Case %0d: Shift until empty", test_num);

            @(posedge clk);
            parallel_load_enable = 1;
            data_in = 16'hFFFF;
            @(posedge clk);
            parallel_load_enable = 0;

            shift_enable = 1;
            repeat(16) @(posedge clk);
            shift_enable = 0;
            #1;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, parallel_load_enable, shift_enable, data_out);
    end

endmodule
