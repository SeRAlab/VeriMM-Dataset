`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [3:0] io_req_in_id;
    reg io_req_valid;
    reg [4:0] io_resp_out_id;
    reg io_resp_valid;
    reg reset;
    wire [4:0] io_req_out_id;
    wire io_req_ready;
    wire [3:0] io_resp_in_id;
    wire io_resp_matches;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_req_in_id(io_req_in_id),
        .io_req_valid(io_req_valid),
        .io_resp_out_id(io_resp_out_id),
        .io_resp_valid(io_resp_valid),
        .reset(reset),
        .io_req_out_id(io_req_out_id),
        .io_req_ready(io_req_ready),
        .io_resp_in_id(io_resp_in_id),
        .io_resp_matches(io_resp_matches)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset and Zero ID Mapping", test_num);
        reset = 1;
        io_req_valid = 0;
        io_req_in_id = 4'h0;
        io_resp_valid = 0;
        io_resp_out_id = 5'h00;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);

        #1;


        check_outputs(5'h00, 1'b1, 4'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Max Request ID (0xF -> 0x0F)", test_num);
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_req_in_id = 4'hF;
        io_req_valid = 1;
        @(posedge clock);
        #1;

        check_outputs(5'h0F, 1'b1, 4'h0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Response ID Truncation (0x1F -> 0xF)", test_num);
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_resp_out_id = 5'h1F;
        io_resp_valid = 1;
        @(posedge clock);
        #1;

        check_outputs(5'h00, 1'b1, 4'hF, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Mid-range Request ID (0xA -> 0x0A)", test_num);
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_req_in_id = 4'hA;
        @(posedge clock);
        #1;

        check_outputs(5'h0A, 1'b1, 4'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Mixed ID Mapping", test_num);
        reset = 1;
        @(posedge clock);
        #1 reset = 0;
        io_req_in_id = 4'h5;
        io_resp_out_id = 5'h12;
        @(posedge clock);
        #1;

        check_outputs(5'h05, 1'b1, 4'h2, 1'b1);
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
        input [4:0] expected_io_req_out_id;
        input expected_io_req_ready;
        input [3:0] expected_io_resp_in_id;
        input expected_io_resp_matches;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_req_out_id === (expected_io_req_out_id ^ io_req_out_id ^ expected_io_req_out_id) &&
                expected_io_req_ready === (expected_io_req_ready ^ io_req_ready ^ expected_io_req_ready) &&
                expected_io_resp_in_id === (expected_io_resp_in_id ^ io_resp_in_id ^ expected_io_resp_in_id) &&
                expected_io_resp_matches === (expected_io_resp_matches ^ io_resp_matches ^ expected_io_resp_matches)) begin
                $display("PASS");
                $display("  Outputs: io_req_out_id=%h, io_req_ready=%b, io_resp_in_id=%h, io_resp_matches=%b",
                         io_req_out_id, io_req_ready, io_resp_in_id, io_resp_matches);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_req_out_id=%h, io_req_ready=%b, io_resp_in_id=%h, io_resp_matches=%b",
                         expected_io_req_out_id, expected_io_req_ready, expected_io_resp_in_id, expected_io_resp_matches);
                $display("  Got:      io_req_out_id=%h, io_req_ready=%b, io_resp_in_id=%h, io_resp_matches=%b",
                         io_req_out_id, io_req_ready, io_resp_in_id, io_resp_matches);
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
