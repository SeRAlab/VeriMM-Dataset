`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] din_data;
    reg din_last;
    reg din_valid;
    reg match_ready;
    wire din_ready;
    wire [63:0] match_data;
    wire match_last;
    wire match_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din_data(din_data),
        .din_last(din_last),
        .din_valid(din_valid),
        .match_ready(match_ready),
        .din_ready(din_ready),
        .match_data(match_data),
        .match_last(match_last),
        .match_valid(match_valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Basic Valid Input", test_num);


        din_data = 64'h1122334455667788;
        din_last = 1'b0;
        din_valid = 1'b1;
        match_ready = 1'b1;



        #1;




        check_outputs(1'b1, 64'h1122334455667788, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Last Packet Processing", test_num);

        din_data = 64'hFFFF_FFFF_0000_0000;
        din_last = 1'b1;
        din_valid = 1'b1;
        match_ready = 1'b1;

        #1;


        check_outputs(1'b1, 64'hFFFF_FFFF_0000_0000, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Backpressure (match_ready low)", test_num);

        din_data = 64'hCAFE_BABE_DEAD_BEEF;
        din_last = 1'b0;
        din_valid = 1'b1;
        match_ready = 1'b0;



        #1;




        check_outputs(1'b0, 64'hCAFE_BABE_DEAD_BEEF, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Invalid Input (din_valid low)", test_num);

        din_data = 64'h0;
        din_last = 1'b0;
        din_valid = 1'b0;
        match_ready = 1'b1;


        #1;



        check_outputs(1'b1, 64'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Boundary Data (All Ones)", test_num);

        din_data = 64'hFFFF_FFFF_FFFF_FFFF;
        din_last = 1'b0;
        din_valid = 1'b1;
        match_ready = 1'b1;

        #1;


        check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFF, 1'b0, 1'b1);
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
        input expected_din_ready;
        input [63:0] expected_match_data;
        input expected_match_last;
        input expected_match_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_din_ready === (expected_din_ready ^ din_ready ^ expected_din_ready) &&
                expected_match_data === (expected_match_data ^ match_data ^ expected_match_data) &&
                expected_match_last === (expected_match_last ^ match_last ^ expected_match_last) &&
                expected_match_valid === (expected_match_valid ^ match_valid ^ expected_match_valid)) begin
                $display("PASS");
                $display("  Outputs: din_ready=%b, match_data=%h, match_last=%b, match_valid=%b",
                         din_ready, match_data, match_last, match_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: din_ready=%b, match_data=%h, match_last=%b, match_valid=%b",
                         expected_din_ready, expected_match_data, expected_match_last, expected_match_valid);
                $display("  Got:      din_ready=%b, match_data=%h, match_last=%b, match_valid=%b",
                         din_ready, match_data, match_last, match_valid);
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

endmodule
