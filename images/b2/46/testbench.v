`timescale 1ns/1ps

module reverse_bits_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] binary_num;
    reg clk;
    reg reset;
    wire [5:0] reversed;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reverse_bits_module dut (
        .binary_num(binary_num),
        .clk(clk),
        .reset(reset),
        .reversed(reversed)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            binary_num = 6'b0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 000001", test_num);
            reset_dut();
            binary_num = 6'b000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b100000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 111111", test_num);
            reset_dut();
            binary_num = 6'b111111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 100000", test_num);
            reset_dut();
            binary_num = 6'b100000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 101010", test_num);
            reset_dut();
            binary_num = 6'b101010;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b010101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 010101", test_num);
            reset_dut();
            binary_num = 6'b010101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b101010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 111000", test_num);
            reset_dut();
            binary_num = 6'b111000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 011110", test_num);
            reset_dut();
            binary_num = 6'b011110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b011110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reversing 000000", test_num);
            reset_dut();
            binary_num = 6'b000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(6'b000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reverse_bits_module Testbench");
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
        input [5:0] expected_reversed;
        begin
            if (expected_reversed === (expected_reversed ^ reversed ^ expected_reversed)) begin
                $display("PASS");
                $display("  Outputs: reversed=%h",
                         reversed);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reversed=%h",
                         expected_reversed);
                $display("  Got:      reversed=%h",
                         reversed);
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
        $dumpvars(0,binary_num, clk, reset, reversed);
    end

endmodule
