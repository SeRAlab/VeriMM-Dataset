`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg control_tag_in;
    reg [31:0] data_in;
    reg dequeue_in;
    reg [6:0] ecc_in;
    reg error_in;
    reg por_req_in;
    reg reset;
    reg tag_in;
    reg valid_in;
    wire control_tag_out;
    wire [31:0] data_out;
    wire dequeue_out;
    wire [6:0] ecc_out;
    wire error_out;
    wire por_req_out;
    wire tag_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .control_tag_in(control_tag_in),
        .data_in(data_in),
        .dequeue_in(dequeue_in),
        .ecc_in(ecc_in),
        .error_in(error_in),
        .por_req_in(por_req_in),
        .reset(reset),
        .tag_in(tag_in),
        .valid_in(valid_in),
        .control_tag_out(control_tag_out),
        .data_out(data_out),
        .dequeue_out(dequeue_out),
        .ecc_out(ecc_out),
        .error_out(error_out),
        .por_req_out(por_req_out),
        .tag_out(tag_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            control_tag_in = 0;
            data_in = 0;
            dequeue_in = 0;
            ecc_in = 0;
            error_in = 0;
            por_req_in = 0;
            tag_in = 0;
            valid_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Basic valid data load", test_num);
            reset_dut();

            data_in = 32'hABCDE123;
            ecc_in = 7'h5A;
            valid_in = 1;
            tag_in = 1;
            control_tag_in = 0;
            error_in = 0;
            dequeue_in = 0;
            por_req_in = 0;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'hABCDE123, 1'b0, 7'h5A, 1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Data gating check (valid_in = 0)", test_num);
            reset_dut();


            data_in = 32'h11112222;
            ecc_in = 7'h1F;
            valid_in = 1;
            @(posedge clk);
            #1;


            data_in = 32'hFFFFFFFF;
            ecc_in = 7'h7F;
            valid_in = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'h11112222, 1'b0, 7'h1F, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Control flags test", test_num);
            reset_dut();

            data_in = 32'h0;
            ecc_in = 7'h0;
            valid_in = 1;
            error_in = 1;
            dequeue_in = 1;
            por_req_in = 1;
            control_tag_in = 1;
            tag_in = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'h0, 1'b1, 7'h0, 1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Successive data stream", test_num);
            reset_dut();

            data_in = 32'hAAAA5555;
            ecc_in = 7'h33;
            valid_in = 1;
            @(posedge clk);
            #1;

            data_in = 32'h5555AAAA;
            ecc_in = 7'h44;
            valid_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 32'h5555AAAA, 1'b0, 7'h44, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset mid-operation", test_num);
            reset_dut();

            data_in = 32'hDEADBEEF;
            valid_in = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 32'h0, 1'b0, 7'h0, 1'b0, 1'b0, 1'b0, 1'b0);
            reset = 0;
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
        input expected_control_tag_out;
        input [31:0] expected_data_out;
        input expected_dequeue_out;
        input [6:0] expected_ecc_out;
        input expected_error_out;
        input expected_por_req_out;
        input expected_tag_out;
        input expected_valid_out;
        begin
            if (expected_control_tag_out === (expected_control_tag_out ^ control_tag_out ^ expected_control_tag_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_dequeue_out === (expected_dequeue_out ^ dequeue_out ^ expected_dequeue_out) &&
                expected_ecc_out === (expected_ecc_out ^ ecc_out ^ expected_ecc_out) &&
                expected_error_out === (expected_error_out ^ error_out ^ expected_error_out) &&
                expected_por_req_out === (expected_por_req_out ^ por_req_out ^ expected_por_req_out) &&
                expected_tag_out === (expected_tag_out ^ tag_out ^ expected_tag_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: control_tag_out=%b, data_out=%h, dequeue_out=%b, ecc_out=%h, error_out=%b, por_req_out=%b, tag_out=%b, valid_out=%b",
                         control_tag_out, data_out, dequeue_out, ecc_out, error_out, por_req_out, tag_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: control_tag_out=%b, data_out=%h, dequeue_out=%b, ecc_out=%h, error_out=%b, por_req_out=%b, tag_out=%b, valid_out=%b",
                         expected_control_tag_out, expected_data_out, expected_dequeue_out, expected_ecc_out, expected_error_out, expected_por_req_out, expected_tag_out, expected_valid_out);
                $display("  Got:      control_tag_out=%b, data_out=%h, dequeue_out=%b, ecc_out=%h, error_out=%b, por_req_out=%b, tag_out=%b, valid_out=%b",
                         control_tag_out, data_out, dequeue_out, ecc_out, error_out, por_req_out, tag_out, valid_out);
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
        $dumpvars(0,clk, control_tag_in, data_in, dequeue_in, ecc_in, error_in, por_req_in, reset, tag_in, valid_in, control_tag_out, data_out, dequeue_out, ecc_out, error_out, por_req_out, tag_out, valid_out);
    end

endmodule
