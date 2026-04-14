`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg i_clk0;
    reg i_clk1;
    reg i_clk2;
    reg [2:0] i_clks;
    reg i_data;
    wire o_clk;
    wire o_clk2;
    wire o_clk3;
    wire o_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_clk0(i_clk0),
        .i_clk1(i_clk1),
        .i_clk2(i_clk2),
        .i_clks(i_clks),
        .i_data(i_data),
        .o_clk(o_clk),
        .o_clk2(o_clk2),
        .o_clk3(o_clk3),
        .o_data(o_data)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk0 = 0;
        forever #5 i_clk0 = ~i_clk0;
    end

        task reset_dut;

    begin
        i_data = 0;

        if (cycle_cnt % 30 != 0 || cycle_cnt == 0) begin
            while (cycle_cnt % 30 != 0) @(posedge i_clk0);
        end

        @(negedge i_clk0);
        i_data = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        i_data = 1;
        repeat(2) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(1, 1, 0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        repeat(6) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(0, 1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        repeat(8) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(0, 0, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        repeat(4) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(1, 1, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        repeat(10) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(0, 0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        repeat(11) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(1, 0, 0, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        repeat(16) @(posedge i_clk0);
        #1;

        #1;


        check_outputs(0, 1, 1, 0);
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
        input expected_o_clk;
        input expected_o_clk2;
        input expected_o_clk3;
        input expected_o_data;
        begin
            if (expected_o_clk === (expected_o_clk ^ o_clk ^ expected_o_clk) &&
                expected_o_clk2 === (expected_o_clk2 ^ o_clk2 ^ expected_o_clk2) &&
                expected_o_clk3 === (expected_o_clk3 ^ o_clk3 ^ expected_o_clk3) &&
                expected_o_data === (expected_o_data ^ o_data ^ expected_o_data)) begin
                $display("PASS");
                $display("  Outputs: o_clk=%b, o_clk2=%b, o_clk3=%b, o_data=%b",
                         o_clk, o_clk2, o_clk3, o_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_clk=%b, o_clk2=%b, o_clk3=%b, o_data=%b",
                         expected_o_clk, expected_o_clk2, expected_o_clk3, expected_o_data);
                $display("  Got:      o_clk=%b, o_clk2=%b, o_clk3=%b, o_data=%b",
                         o_clk, o_clk2, o_clk3, o_data);
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
        $dumpvars(0,i_clk0, i_clk1, i_clk2, i_clks, i_data, o_clk, o_clk2, o_clk3, o_data);
    end

endmodule
