`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data;
    reg reset;
    wire greater_than_32767;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .reset(reset),
        .greater_than_32767(greater_than_32767),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            data = 16'h0005;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'h0001;
            @(posedge clk);
            data = 16'h0002;
            @(posedge clk);
            data = 16'h0003;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 16'h000C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data = 16'h3FFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 16'h7FFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            data = 16'h4000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            data = 16'hFFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            data = 16'h4000;
            @(posedge clk);
            data = 16'h4000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            data = 16'h8001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 16'h0002);
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
        input expected_greater_than_32767;
        input [15:0] expected_result;
        begin
            if (expected_greater_than_32767 === (expected_greater_than_32767 ^ greater_than_32767 ^ expected_greater_than_32767) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: greater_than_32767=%b, result=%h",
                         greater_than_32767, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_than_32767=%b, result=%h",
                         expected_greater_than_32767, expected_result);
                $display("  Got:      greater_than_32767=%b, result=%h",
                         greater_than_32767, result);
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
        $dumpvars(0,clk, data, reset, greater_than_32767, result);
    end

endmodule
