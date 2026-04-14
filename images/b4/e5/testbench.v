`timescale 1ns/1ps

module Shift_register_8_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] D;
    reg clk;
    reg load;
    reg rst_n;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Shift_register_8 dut (
        .D(D),
        .clk(clk),
        .load(load),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            load = 0;
            D = 8'h00;
            @(negedge clk);
            rst_n = 1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %03d: Parallel Load", test_num);
            D = 8'hA5;
            load = 1;
            @(negedge clk);
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %03d: Load 0x01 and Shift Left Once", test_num);
            D = 8'h01;
            load = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %03d: Load 0x07 and Shift Left 3 times", test_num);
            D = 8'h07;
            load = 1;
            @(negedge clk);
            load = 0;
            repeat(3) @(negedge clk);
            #1;

            check_outputs(8'h38);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %03d: Shift MSB out", test_num);
            D = 8'h80;
            load = 1;
            @(negedge clk);
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %03d: Shift from Reset state", test_num);
            load = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %03d: Load while shifting (Priority Check)", test_num);
            D = 8'h01;
            load = 1;
            @(negedge clk);
            D = 8'hFF;
            load = 1;
            @(negedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Shift_register_8 Testbench");
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
        input [7:0] expected_Q;
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
        $dumpvars(0,D, clk, load, rst_n, Q);
    end

endmodule
