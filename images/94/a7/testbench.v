`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg deque;
    reg enque;
    reg [3:0] enque_data;
    reg reset;
    wire [3:0] deque_data;
    wire dequed;
    wire enqued;
    wire is_empty;
    wire is_full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .deque(deque),
        .enque(enque),
        .enque_data(enque_data),
        .reset(reset),
        .deque_data(deque_data),
        .dequed(dequed),
        .enqued(enqued),
        .is_empty(is_empty),
        .is_full(is_full)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        enque = 0;
        deque = 0;
        enque_data = 0;
        @(posedge clock);
        #1;
        reset = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running testcase%03d: Single Enqueue/Dequeue", test_num);
        reset_dut();


        enque = 1; enque_data = 4'hA;
        @(posedge clock); #1;
        enque = 0;


        deque = 1;
        @(posedge clock); #1;
        deque = 0;


        #1;



        check_outputs(4'hA, 1'b1, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running testcase%03d: Fill FIFO", test_num);
        reset_dut();

        enque = 1;
        enque_data = 4'h1; @(posedge clock); #1;
        enque_data = 4'h2; @(posedge clock); #1;
        enque_data = 4'h3; @(posedge clock); #1;
        enque_data = 4'h4; @(posedge clock); #1;
        enque = 0;


        #1;



        check_outputs(4'h0, 1'b0, 1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running testcase%03d: Overflow Check", test_num);
        reset_dut();

        enque = 1;
        enque_data = 4'h1; @(posedge clock); #1;
        enque_data = 4'h2; @(posedge clock); #1;
        enque_data = 4'h3; @(posedge clock); #1;
        enque_data = 4'h4; @(posedge clock); #1;

        enque_data = 4'h5; @(posedge clock); #1;
        enque = 0;


        #1;



        check_outputs(4'h0, 1'b0, 1'b0, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running testcase%03d: Empty and Underflow Check", test_num);
        reset_dut();


        enque = 1; enque_data = 4'hF; @(posedge clock); #1;
        enque = 0; deque = 1; @(posedge clock); #1;

        deque = 1; @(posedge clock); #1;
        deque = 0;


        #1;



        check_outputs(4'hF, 1'b0, 1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running testcase%03d: Pointer Wrap-around", test_num);
        reset_dut();


        enque = 1; enque_data = 4'h1; @(posedge clock); #1;
        enque_data = 4'h2; @(posedge clock); #1;
        enque = 0;

        deque = 1; @(posedge clock); #1;
        @(posedge clock); #1;
        deque = 0;

        enque = 1;
        enque_data = 4'h7; @(posedge clock); #1;
        enque_data = 4'h8; @(posedge clock); #1;
        enque_data = 4'h9; @(posedge clock); #1;
        enque = 0;


        #1;



        check_outputs(4'h2, 1'b1, 1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running testcase%03d: Sequential Integrity", test_num);
        reset_dut();

        enque = 1;
        enque_data = 4'hA; @(posedge clock); #1;
        enque_data = 4'hB; @(posedge clock); #1;
        enque_data = 4'hC; @(posedge clock); #1;
        enque_data = 4'hD; @(posedge clock); #1;
        enque = 0;

        deque = 1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        @(posedge clock); #1;
        deque = 0;


        #1;



        check_outputs(4'hD, 1'b1, 1'b0, 1'b1, 1'b0);
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
        input [3:0] expected_deque_data;
        input expected_dequed;
        input expected_enqued;
        input expected_is_empty;
        input expected_is_full;
        begin
            if (expected_deque_data === (expected_deque_data ^ deque_data ^ expected_deque_data) &&
                expected_dequed === (expected_dequed ^ dequed ^ expected_dequed) &&
                expected_enqued === (expected_enqued ^ enqued ^ expected_enqued) &&
                expected_is_empty === (expected_is_empty ^ is_empty ^ expected_is_empty) &&
                expected_is_full === (expected_is_full ^ is_full ^ expected_is_full)) begin
                $display("PASS");
                $display("  Outputs: deque_data=%h, dequed=%b, enqued=%b, is_empty=%b, is_full=%b",
                         deque_data, dequed, enqued, is_empty, is_full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deque_data=%h, dequed=%b, enqued=%b, is_empty=%b, is_full=%b",
                         expected_deque_data, expected_dequed, expected_enqued, expected_is_empty, expected_is_full);
                $display("  Got:      deque_data=%h, dequed=%b, enqued=%b, is_empty=%b, is_full=%b",
                         deque_data, dequed, enqued, is_empty, is_full);
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
        $dumpvars(0,clock, deque, enque, enque_data, reset, deque_data, dequed, enqued, is_empty, is_full);
    end

endmodule
