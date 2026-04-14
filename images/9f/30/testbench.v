`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] dataa;
    reg enable;
    reg resetn;
    reg stall_in;
    reg valid_in;
    wire [31:0] result_exp;
    wire [31:0] result_fr;
    wire stall_out;
    wire valid_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .dataa(dataa),
        .enable(enable),
        .resetn(resetn),
        .stall_in(stall_in),
        .valid_in(valid_in),
        .result_exp(result_exp),
        .result_fr(result_fr),
        .stall_out(stall_out),
        .valid_out(valid_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            resetn = 0;
            enable = 0;
            valid_in = 0;
            stall_in = 0;
            dataa = 0;
            @(posedge clock);
            #1;
            resetn = 1;
            enable = 1;
            @(posedge clock);
            #1;
        end
        endtask
    task wait_for_valid;

        begin
            integer timeout;
            timeout = 0;
            while (!valid_out && timeout < 100) begin
                @(posedge clock);
                timeout = timeout + 1;
            end
            if (timeout >= 100) $display("Error: Timeout waiting for valid_out");
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            dataa = 32'h3f800000;
            valid_in = 1;
            @(posedge clock);
            #1;
            valid_in = 0;
            wait_for_valid();

            #1;


            check_outputs(32'h0000007F, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            dataa = 32'hc0200000;
            valid_in = 1;
            @(posedge clock);
            #1;
            valid_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h00000080, 32'h00200000, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            dataa = 32'h00000000;
            valid_in = 1;
            @(posedge clock);
            #1;
            valid_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h00000000, 32'h00000000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            dataa = 32'h41200000;
            valid_in = 1;
            stall_in = 1;
            @(posedge clock);
            #1;
            valid_in = 0;

            repeat(3) @(posedge clock);
            #1;
            stall_in = 0;
            wait_for_valid();
            #1;

            check_outputs(32'h00000082, 32'h00200000, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            enable = 0;
            dataa = 32'h3f800000;
            valid_in = 1;
            repeat(5) @(posedge clock);
            #1;

            if (valid_out == 0) begin
                $display("PASS - Case 5: Module stayed idle while enable=0");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL - Case 5: Module processed data while enable=0");
                fail_count = fail_count + 1;
            end


            enable = 1;
            wait_for_valid();
            #1;

            check_outputs(32'h0000007F, 32'h00000000, 1'b0, 1'b1);
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
        input [31:0] expected_result_exp;
        input [31:0] expected_result_fr;
        input expected_stall_out;
        input expected_valid_out;
        begin
            if (expected_result_exp === (expected_result_exp ^ result_exp ^ expected_result_exp) &&
                expected_result_fr === (expected_result_fr ^ result_fr ^ expected_result_fr) &&
                expected_stall_out === (expected_stall_out ^ stall_out ^ expected_stall_out) &&
                expected_valid_out === (expected_valid_out ^ valid_out ^ expected_valid_out)) begin
                $display("PASS");
                $display("  Outputs: result_exp=%h, result_fr=%h, stall_out=%b, valid_out=%b",
                         result_exp, result_fr, stall_out, valid_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_exp=%h, result_fr=%h, stall_out=%b, valid_out=%b",
                         expected_result_exp, expected_result_fr, expected_stall_out, expected_valid_out);
                $display("  Got:      result_exp=%h, result_fr=%h, stall_out=%b, valid_out=%b",
                         result_exp, result_fr, stall_out, valid_out);
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
        $dumpvars(0,clock, dataa, enable, resetn, stall_in, valid_in, result_exp, result_fr, stall_out, valid_out);
    end

endmodule
