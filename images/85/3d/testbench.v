`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] bin_in;
    reg rst;
    wire [3:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin_in(bin_in),
        .rst(rst),
        .gray_out(gray_out)
    );

    // Clock generation (10ns period)
    initial begin
        rst = 0;
        forever #5 rst = ~rst;
    end

        task reset_dut;

        begin
            bin_in = 4'b0000;
            wait(rst == 1);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b0000;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b0001;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b0010;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b0100;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b1000;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b1111;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b1010;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin_in = 4'b0101;
            wait(rst == 0);
            #2;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            bin_in = 4'b1111;
            wait(rst == 1);
            #2;
            #1;

            check_outputs(4'b0000);
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
        input [3:0] expected_gray_out;
        begin
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
        $dumpvars(0,bin_in, rst, gray_out);
    end

endmodule
