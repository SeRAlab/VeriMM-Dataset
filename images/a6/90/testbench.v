`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [41:0] fixed_num;
    wire overflow;
    wire [12:0] round;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .fixed_num(fixed_num),
        .overflow(overflow),
        .round(round)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            fixed_num = 42'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            fixed_num = 42'h00000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            fixed_num = 42'h00020000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            fixed_num = 42'h00030000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            fixed_num = 42'h0FFE0000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h07FF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            fixed_num = 42'h0FFF0000000;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 13'h07FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            fixed_num = 42'h20000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            fixed_num = 42'h3FF10000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            fixed_num = 42'h3FFD0000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h1FFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            fixed_num = 42'h20010000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 13'h1001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_dut();
            fixed_num = 42'h10000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 13'h07FF);
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
        testcase010();
        
        
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
        input expected_overflow;
        input [12:0] expected_round;
        begin
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_round === (expected_round ^ round ^ expected_round)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, round=%h",
                         overflow, round);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, round=%h",
                         expected_overflow, expected_round);
                $display("  Got:      overflow=%b, round=%h",
                         overflow, round);
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
        $dumpvars(0,clk, fixed_num, overflow, round);
    end

endmodule
