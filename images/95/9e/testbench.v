`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] binary_in;
    reg gray_ctrl;
    reg rst_n;
    wire [3:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .gray_ctrl(gray_ctrl),
        .rst_n(rst_n),
        .gray_out(gray_out)
    );

    // Clock generation (10ns period)
    initial begin
        gray_ctrl = 0;
        forever #5 gray_ctrl = ~gray_ctrl;
    end

        task reset_dut;

    begin
        rst_n = 0;
        binary_in = 0;
        @(posedge gray_ctrl);
        #2 rst_n = 1;
        @(posedge gray_ctrl);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Verification", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0001 to Gray", test_num);
        reset_dut();
        binary_in = 4'b0001;
        @(posedge gray_ctrl);
        @(negedge gray_ctrl);
        #1;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 0011 to Gray", test_num);
        reset_dut();
        binary_in = 4'b0011;
        @(posedge gray_ctrl);
        @(negedge gray_ctrl);
        #1;
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 1010 to Gray", test_num);
        reset_dut();
        binary_in = 4'b1010;
        @(posedge gray_ctrl);
        @(negedge gray_ctrl);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary 1111 to Gray", test_num);
        reset_dut();
        binary_in = 4'b1111;
        @(posedge gray_ctrl);
        @(negedge gray_ctrl);
        #1;
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Data stability without gray_ctrl trigger", test_num);
        reset_dut();
        binary_in = 4'b0110;
        @(posedge gray_ctrl);
        @(negedge gray_ctrl);
        #1;
        binary_in = 4'b1111;
        #2;
        #1;

        check_outputs(4'b0101);
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
        $dumpvars(0,binary_in, gray_ctrl, rst_n, gray_out);
    end

endmodule
