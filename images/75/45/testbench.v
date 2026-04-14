`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg valid_in;
    wire [9:0] accu_out;
    wire ready_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid_in(valid_in),
        .accu_out(accu_out),
        .ready_out(ready_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            valid_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(10'h000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Single Data (Parity 1)", test_num);
            reset_dut();
            data_in = 8'h01;
            valid_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Single Data (Parity 0)", test_num);
            reset_dut();
            data_in = 8'h03;
            valid_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Accumulating Multiple Parity Bits", test_num);
            reset_dut();


            data_in = 8'h01; valid_in = 1;
            @(posedge clk);


            data_in = 8'h02; valid_in = 1;
            @(posedge clk);


            data_in = 8'h04; valid_in = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'd3, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Check 'otherwise' Parity Output", test_num);
            reset_dut();


            data_in = 8'h01; valid_in = 1;
            @(posedge clk);


            data_in = 8'h80;
            valid_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'd1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Test Case %0d: Continuous Parity Accumulation", test_num);
            reset_dut();
            data_in = 8'hFF;
            valid_in = 1;
            for(i=0; i<10; i=i+1) @(posedge clk);

            data_in = 8'h01;
            for(i=0; i<5; i=i+1) @(posedge clk);

            #1;

            #1;


            check_outputs(10'd5, 1'b1);
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
        input [9:0] expected_accu_out;
        input expected_ready_out;
        begin
            if (expected_accu_out === (expected_accu_out ^ accu_out ^ expected_accu_out) &&
                expected_ready_out === (expected_ready_out ^ ready_out ^ expected_ready_out)) begin
                $display("PASS");
                $display("  Outputs: accu_out=%h, ready_out=%b",
                         accu_out, ready_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: accu_out=%h, ready_out=%b",
                         expected_accu_out, expected_ready_out);
                $display("  Got:      accu_out=%h, ready_out=%b",
                         accu_out, ready_out);
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
        $dumpvars(0,clk, data_in, reset, valid_in, accu_out, ready_out);
    end

endmodule
