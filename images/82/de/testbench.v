`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary;
    reg clk;
    wire [3:0] ones_comp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .clk(clk),
        .ones_comp(ones_comp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            binary = 4'b0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b0000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b0001;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b0101;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b0111;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b1000;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b1010;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            binary = 4'b1111;
            @(posedge clk);
            #1;
            $display("Testcase %0d: binary = %b", test_num, binary);
            #1;

            check_outputs(4'b0001);
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
        input [3:0] expected_ones_comp;
        begin
            if (expected_ones_comp === (expected_ones_comp ^ ones_comp ^ expected_ones_comp)) begin
                $display("PASS");
                $display("  Outputs: ones_comp=%h",
                         ones_comp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones_comp=%h",
                         expected_ones_comp);
                $display("  Got:      ones_comp=%h",
                         ones_comp);
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
        $dumpvars(0,binary, clk, ones_comp);
    end

endmodule
