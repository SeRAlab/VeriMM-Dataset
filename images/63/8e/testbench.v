`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] key_input;
    wire [4:0] key_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .key_input(key_input),
        .key_code(key_code)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        key_input = 9'b0;


        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 0, Note 50", test_num);
        reset_dut();
        key_input = {2'd0, 7'd50};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 1, Note 25", test_num);
        reset_dut();
        key_input = {2'd1, 7'd25};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd25);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 1, Note 31", test_num);
        reset_dut();
        key_input = {2'd1, 7'd31};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 2, Note 10", test_num);
        reset_dut();
        key_input = {2'd2, 7'd10};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 2, Note 16 (Overflow check)", test_num);
        reset_dut();
        key_input = {2'd2, 7'd16};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 3, Note 7", test_num);
        reset_dut();
        key_input = {2'd3, 7'd7};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd21);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %03d: Range 3, Note 11 (Overflow check)", test_num);
        reset_dut();
        key_input = {2'd3, 7'd11};
        @(posedge clk);
        #1;
        #1;

        check_outputs(5'd1);
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
        input [4:0] expected_key_code;
        begin
            if (expected_key_code === (expected_key_code ^ key_code ^ expected_key_code)) begin
                $display("PASS");
                $display("  Outputs: key_code=%h",
                         key_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_code=%h",
                         expected_key_code);
                $display("  Got:      key_code=%h",
                         key_code);
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
        $dumpvars(0,clk, key_input, key_code);
    end

endmodule
