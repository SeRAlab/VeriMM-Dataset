`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg SI;
    reg clk;
    reg reset;
    wire SO;
    wire [3:0] twos_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .SI(SI),
        .clk(clk),
        .reset(reset),
        .SO(SO),
        .twos_comp(twos_comp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            SI = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            D = 4'b1011;
            reset_dut();

            #1;


            check_outputs(1'b1, 4'b0101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            D = 4'b0110;
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            D = 4'b0001;
            reset_dut();
            SI = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b0011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            D = 4'b1110;
            reset_dut();
            SI = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            D = 4'b0101;
            reset_dut();
            SI = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            D = 4'b1001;
            reset_dut();
            SI = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0010);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            D = 4'b1000;
            reset_dut();

            #1;


            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            D = 4'b0000;
            reset_dut();
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            D = 4'b0111;
            reset_dut();
            SI = 1; @(posedge clk);
            SI = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'b0010);
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
        input expected_SO;
        input [3:0] expected_twos_comp;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO) &&
                expected_twos_comp === (expected_twos_comp ^ twos_comp ^ expected_twos_comp)) begin
                $display("PASS");
                $display("  Outputs: SO=%b, twos_comp=%h",
                         SO, twos_comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b, twos_comp=%h",
                         expected_SO, expected_twos_comp);
                $display("  Got:      SO=%b, twos_comp=%h",
                         SO, twos_comp);
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
        $dumpvars(0,D, SI, clk, reset, SO, twos_comp);
    end

endmodule
