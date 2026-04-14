`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg list_ack;
    reg [7:0] list_value;
    reg list_value_valid;
    reg ready;
    reg tail_req;
    wire done;
    wire [7:0] head;
    wire head_valid;
    wire list_req;
    wire tail_ack;
    wire [7:0] tail_value;
    wire tail_value_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .list_ack(list_ack),
        .list_value(list_value),
        .list_value_valid(list_value_valid),
        .ready(ready),
        .tail_req(tail_req),
        .done(done),
        .head(head),
        .head_valid(head_valid),
        .list_req(list_req),
        .tail_ack(tail_ack),
        .tail_value(tail_value),
        .tail_value_valid(tail_value_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            ready = 0;
            list_ack = 0;
            list_value = 8'h00;
            list_value_valid = 0;
            tail_req = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running testcase%03d: Reset/Idle Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(0, 8'h00, 0, 0, 0, 8'h00, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running testcase%03d: Head Acquisition", test_num);
            reset_dut();

            ready = 1;
            @(posedge clock);
            #1;

            list_ack = 1;
            list_value = 8'hA5;
            list_value_valid = 1;
            @(posedge clock);
            #1;

            list_ack = 0;
            list_value_valid = 0;



            #1;




            check_outputs(0, 8'hA5, 1, 0, 0, 8'h00, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running testcase%03d: Tail Request Handling", test_num);
            reset_dut();


            ready = 1;
            @(posedge clock); #1;
            list_ack = 1;
            list_value = 8'h55;
            list_value_valid = 1;
            @(posedge clock); #1;
            list_ack = 0;
            list_value_valid = 0;


            tail_req = 1;
            @(posedge clock); #1;



            #1;




            check_outputs(0, 8'h55, 1, 0, 1, 8'h00, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running testcase%03d: Ready De-assertion Mid-process", test_num);
            reset_dut();

            ready = 1;
            @(posedge clock); #1;

            list_ack = 1;
            list_value = 8'hFF;
            list_value_valid = 1;
            @(posedge clock); #1;


            ready = 0;
            @(posedge clock); #1;


            #1;



            check_outputs(0, 8'h00, 0, 0, 0, 8'h00, 0);
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
        input expected_done;
        input [7:0] expected_head;
        input expected_head_valid;
        input expected_list_req;
        input expected_tail_ack;
        input [7:0] expected_tail_value;
        input expected_tail_value_valid;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_head === (expected_head ^ head ^ expected_head) &&
                expected_head_valid === (expected_head_valid ^ head_valid ^ expected_head_valid) &&
                expected_list_req === (expected_list_req ^ list_req ^ expected_list_req) &&
                expected_tail_ack === (expected_tail_ack ^ tail_ack ^ expected_tail_ack) &&
                expected_tail_value === (expected_tail_value ^ tail_value ^ expected_tail_value) &&
                expected_tail_value_valid === (expected_tail_value_valid ^ tail_value_valid ^ expected_tail_value_valid)) begin
                $display("PASS");
                $display("  Outputs: done=%b, head=%h, head_valid=%b, list_req=%b, tail_ack=%b, tail_value=%h, tail_value_valid=%b",
                         done, head, head_valid, list_req, tail_ack, tail_value, tail_value_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, head=%h, head_valid=%b, list_req=%b, tail_ack=%b, tail_value=%h, tail_value_valid=%b",
                         expected_done, expected_head, expected_head_valid, expected_list_req, expected_tail_ack, expected_tail_value, expected_tail_value_valid);
                $display("  Got:      done=%b, head=%h, head_valid=%b, list_req=%b, tail_ack=%b, tail_value=%h, tail_value_valid=%b",
                         done, head, head_valid, list_req, tail_ack, tail_value, tail_value_valid);
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
        $dumpvars(0,clock, list_ack, list_value, list_value_valid, ready, tail_req, done, head, head_valid, list_req, tail_ack, tail_value, tail_value_valid);
    end

endmodule
