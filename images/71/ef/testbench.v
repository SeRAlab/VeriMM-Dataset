`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] head;
    reg ready;
    reg req;
    reg tail_ack;
    reg [7:0] tail_value;
    reg tail_value_valid;
    wire ack;
    wire tail_req;
    wire [7:0] value;
    wire value_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .head(head),
        .ready(ready),
        .req(req),
        .tail_ack(tail_ack),
        .tail_value(tail_value),
        .tail_value_valid(tail_value_valid),
        .ack(ack),
        .tail_req(tail_req),
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
            ready = 0;
            head = 8'h00;
            req = 0;
            tail_ack = 0;
            tail_value = 8'h00;
            tail_value_valid = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            ready = 1;
            req = 1;
            head = 8'hAA;
            @(posedge clock);
            #2;

            #1;


            check_outputs(1'b1, 1'b0, 8'hAA, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            ready = 1;
            req = 0;
            @(posedge clock);
            #2;

            #1;


            check_outputs(1'b0, 1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            ready = 0;
            req = 1;
            tail_value = 8'h55;
            @(posedge clock);
            #1;

            if (tail_req === 1'b1) begin
                tail_ack = 1;
                tail_value_valid = 1;
                @(posedge clock);
                #2;

                #1;


                check_outputs(1'b1, 1'b0, 8'h55, 1'b1);
            end else begin
                $display("FAIL: tail_req not asserted when ready=0 and req=1");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            ready = 1;
            req = 1;
            head = 8'hF0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'hF0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            ready = 0;
            req = 1;
            @(posedge clock);
            #1;

            ready = 1;
            head = 8'h33;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1, 1'b0, 8'h33, 1'b1);
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
        input expected_ack;
        input expected_tail_req;
        input [7:0] expected_value;
        input expected_value_valid;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_tail_req === (expected_tail_req ^ tail_req ^ expected_tail_req) &&
                expected_value === (expected_value ^ value ^ expected_value) &&
                expected_value_valid === (expected_value_valid ^ value_valid ^ expected_value_valid)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, tail_req=%b, value=%h, value_valid=%b",
                         ack, tail_req, value, value_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, tail_req=%b, value=%h, value_valid=%b",
                         expected_ack, expected_tail_req, expected_value, expected_value_valid);
                $display("  Got:      ack=%b, tail_req=%b, value=%h, value_valid=%b",
                         ack, tail_req, value, value_valid);
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
        $dumpvars(0,clock, head, ready, req, tail_ack, tail_value, tail_value_valid, ack, tail_req, value, value_valid);
    end

endmodule
