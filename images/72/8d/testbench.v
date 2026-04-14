`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [25:0] Data_i;
    reg bit_shift_i;
    reg clk;
    reg select_i;
    wire [25:0] Data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_i(Data_i),
        .bit_shift_i(bit_shift_i),
        .clk(clk),
        .select_i(select_i),
        .Data_o(Data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Data_i = 26'b0;
            bit_shift_i = 0;
            select_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Left Rotate", test_num);
            Data_i = 26'h2000001;
            select_i = 1;
            bit_shift_i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000003);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Right Rotate", test_num);
            Data_i = 26'h2000001;
            select_i = 0;
            bit_shift_i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h3000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Left Shift", test_num);
            Data_i = 26'h2000001;
            select_i = 1;
            bit_shift_i = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h0000002);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Right Shift", test_num);
            Data_i = 26'h2000001;
            select_i = 0;
            bit_shift_i = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h1000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones Rotate", test_num);
            Data_i = 26'h3FFFFFF;
            select_i = 1;
            bit_shift_i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h3FFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits Rotate", test_num);
            Data_i = 26'h2AAAAAA;
            select_i = 1;
            bit_shift_i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(26'h1555555);
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
        input [25:0] expected_Data_o;
        begin
            if (expected_Data_o === (expected_Data_o ^ Data_o ^ expected_Data_o)) begin
                $display("PASS");
                $display("  Outputs: Data_o=%h",
                         Data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Data_o=%h",
                         expected_Data_o);
                $display("  Got:      Data_o=%h",
                         Data_o);
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
        $dumpvars(0,Data_i, bit_shift_i, clk, select_i, Data_o);
    end

endmodule
