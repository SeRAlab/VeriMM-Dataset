`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg listA_ack;
    reg [7:0] listA_value;
    reg listA_value_valid;
    reg listB_ack;
    reg [7:0] listB_value;
    reg listB_value_valid;
    reg listC_req;
    reg [7:0] listC_value;
    reg listC_value_valid;
    reg ready;
    reg req;
    wire ack;
    wire listA_req;
    wire listB_req;
    wire [7:0] value;
    wire value_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .listA_ack(listA_ack),
        .listA_value(listA_value),
        .listA_value_valid(listA_value_valid),
        .listB_ack(listB_ack),
        .listB_value(listB_value),
        .listB_value_valid(listB_value_valid),
        .listC_req(listC_req),
        .listC_value(listC_value),
        .listC_value_valid(listC_value_valid),
        .ready(ready),
        .req(req),
        .ack(ack),
        .listA_req(listA_req),
        .listB_req(listB_req),
        .value(value),
        .value_valid(value_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            req = 0;
            ready = 0;
            listA_ack = 0;
            listA_value = 8'h00;
            listA_value_valid = 0;
            listB_ack = 0;
            listB_value = 8'h00;
            listB_value_valid = 0;
            listC_req = 0;
            listC_value = 8'h00;
            listC_value_valid = 0;
            repeat(2) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: List C Priority");
            req = 1;
            listC_req = 1;
            listC_value = 8'hC1;
            listC_value_valid = 1;
            ready = 1;

            listA_ack = 1;
            listB_ack = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'hC1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: List A Selection");
            req = 1;
            listC_req = 0;
            listA_ack = 1;
            listA_value = 8'hA2;
            listA_value_valid = 1;
            ready = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 8'hA2, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: List B Selection");
            req = 1;
            listC_req = 0;
            listA_ack = 0;
            listB_ack = 1;
            listB_value = 8'hB3;
            listB_value_valid = 1;
            ready = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 8'hB3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Arbitration Priority A > B");
            req = 1;
            listC_req = 0;
            listA_ack = 1;
            listA_value = 8'hA4;
            listA_value_valid = 1;
            listB_ack = 1;
            listB_value = 8'hB4;
            listB_value_valid = 1;
            ready = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 8'hA4, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Ready Gating");
            req = 1;
            listC_req = 1;
            listC_value = 8'hC5;
            listC_value_valid = 1;
            ready = 0;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Idle State");
            req = 0;
            listC_req = 0;
            ready = 1;
            repeat(3) @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 8'h00, 1'b0);
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
        input expected_ack;
        input expected_listA_req;
        input expected_listB_req;
        input [7:0] expected_value;
        input expected_value_valid;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_listA_req === (expected_listA_req ^ listA_req ^ expected_listA_req) &&
                expected_listB_req === (expected_listB_req ^ listB_req ^ expected_listB_req) &&
                expected_value === (expected_value ^ value ^ expected_value) &&
                expected_value_valid === (expected_value_valid ^ value_valid ^ expected_value_valid)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, listA_req=%b, listB_req=%b, value=%h, value_valid=%b",
                         ack, listA_req, listB_req, value, value_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, listA_req=%b, listB_req=%b, value=%h, value_valid=%b",
                         expected_ack, expected_listA_req, expected_listB_req, expected_value, expected_value_valid);
                $display("  Got:      ack=%b, listA_req=%b, listB_req=%b, value=%h, value_valid=%b",
                         ack, listA_req, listB_req, value, value_valid);
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
        $dumpvars(0,clock, listA_ack, listA_value, listA_value_valid, listB_ack, listB_value, listB_value_valid, listC_req, listC_value, listC_value_valid, ready, req, ack, listA_req, listB_req, value, value_valid);
    end

endmodule
