`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DataIn;
    reg DataInColor;
    reg [5:0] DataInCount;
    reg DataInEnable;
    reg TableColor;
    reg [5:0] TableNumber;
    reg clk;
    reg rst;
    wire [7:0] TableData;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DataIn(DataIn),
        .DataInColor(DataInColor),
        .DataInCount(DataInCount),
        .DataInEnable(DataInEnable),
        .TableColor(TableColor),
        .TableNumber(TableNumber),
        .clk(clk),
        .rst(rst),
        .TableData(TableData)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            DataInEnable = 0;
            DataInColor = 0;
            DataInCount = 0;
            DataIn = 0;
            TableColor = 0;
            TableNumber = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            DataInEnable = 1;
            DataInColor = 0;

            DataInCount = 6'd0; DataIn = 8'hA1; @(negedge clk);
            DataInCount = 6'd32; DataIn = 8'hB2; @(negedge clk);
            DataInCount = 6'd63; DataIn = 8'hC3; @(negedge clk);

            DataInEnable = 0;


            TableColor = 0;

            TableNumber = 6'd0; @(posedge clk); #2;
            $display("Test 001.1: Y[0]");
            #1;

            check_outputs(8'hA1);

            TableNumber = 6'd32; @(posedge clk); #2;
            $display("Test 001.2: Y[32]");
            #1;

            check_outputs(8'hB2);

            TableNumber = 6'd63; @(posedge clk); #2;
            $display("Test 001.3: Y[63]");
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            DataInEnable = 1;
            DataInColor = 1;

            DataInCount = 6'd5; DataIn = 8'h55; @(negedge clk);
            DataInCount = 6'd10; DataIn = 8'hAA; @(negedge clk);

            DataInEnable = 0;


            TableColor = 1;

            TableNumber = 6'd5; @(posedge clk); #2;
            $display("Test 002.1: C[5]");
            #1;

            check_outputs(8'h55);

            TableNumber = 6'd10; @(posedge clk); #2;
            $display("Test 002.2: C[10]");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            DataInEnable = 1;
            DataInCount = 6'd15;

            DataInColor = 0; DataIn = 8'h11; @(negedge clk);
            DataInColor = 1; DataIn = 8'hEE; @(negedge clk);

            DataInEnable = 0;


            TableColor = 0; TableNumber = 6'd15; @(posedge clk); #2;
            $display("Test 003.1: Verify Y[15] is independent");
            #1;

            check_outputs(8'h11);


            TableColor = 1; TableNumber = 6'd15; @(posedge clk); #2;
            $display("Test 003.2: Verify C[15] is independent");
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            DataInEnable = 1;
            DataInColor = 0;
            DataInCount = 6'd20;
            DataIn = 8'h77;
            @(negedge clk);


            DataInEnable = 0;
            DataIn = 8'hFF;
            @(negedge clk);


            TableColor = 0;
            TableNumber = 6'd20;
            @(posedge clk); #2;
            $display("Test 004: Verify DataInEnable prevents writing");
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();


            @(negedge clk);
            DataInEnable = 1;
            DataInColor = 0;
            for (i = 0; i < 64; i = i + 1) begin
                DataInCount = i;
                DataIn = i + 8'h10;
                @(negedge clk);
            end
            DataInEnable = 0;


            TableColor = 0;
            TableNumber = 6'd63;
            @(posedge clk); #2;
            $display("Test 005: Verify Y[63] after full fill");
            #1;

            check_outputs(8'h10 + 63);
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
        input [7:0] expected_TableData;
        begin
            if (expected_TableData === (expected_TableData ^ TableData ^ expected_TableData)) begin
                $display("PASS");
                $display("  Outputs: TableData=%h",
                         TableData);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: TableData=%h",
                         expected_TableData);
                $display("  Got:      TableData=%h",
                         TableData);
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
        $dumpvars(0,DataIn, DataInColor, DataInCount, DataInEnable, TableColor, TableNumber, clk, rst, TableData);
    end

endmodule
