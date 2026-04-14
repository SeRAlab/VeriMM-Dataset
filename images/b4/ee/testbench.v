`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DataIn;
    reg clk;
    reg rst;
    wire [3:0] DataOut1;
    wire [3:0] DataOut2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataIn(DataIn),
        .clk(clk),
        .rst(rst),
        .DataOut1(DataOut1),
        .DataOut2(DataOut2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            DataIn = 4'b0;
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
            $display("Test %0d: Load pattern 4'h5", test_num);
            reset_dut();
            DataIn = 4'h5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h5, 4'h5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load pattern 4'hA", test_num);
            reset_dut();
            DataIn = 4'hA;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hA, 4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load pattern 4'hF", test_num);
            reset_dut();
            DataIn = 4'hF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load pattern 4'h0", test_num);
            reset_dut();

            DataIn = 4'h7;
            @(posedge clk);
            #1;
            DataIn = 4'h0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify Reset Priority over DataIn", test_num);
            reset_dut();
            DataIn = 4'hB;
            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data stability between clock edges", test_num);
            reset_dut();
            DataIn = 4'h3;
            @(posedge clk);
            #1;
            DataIn = 4'hC;
            #2;
            #1;

            check_outputs(4'h3, 4'h3);
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
        input [3:0] expected_DataOut1;
        input [3:0] expected_DataOut2;
        begin
            if (expected_DataOut1 === (expected_DataOut1 ^ DataOut1 ^ expected_DataOut1) &&
                expected_DataOut2 === (expected_DataOut2 ^ DataOut2 ^ expected_DataOut2)) begin
                $display("PASS");
                $display("  Outputs: DataOut1=%h, DataOut2=%h",
                         DataOut1, DataOut2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DataOut1=%h, DataOut2=%h",
                         expected_DataOut1, expected_DataOut2);
                $display("  Got:      DataOut1=%h, DataOut2=%h",
                         DataOut1, DataOut2);
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
        $dumpvars(0,DataIn, clk, rst, DataOut1, DataOut2);
    end

endmodule
