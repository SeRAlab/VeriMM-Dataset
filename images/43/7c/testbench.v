`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [64:0] process_input;
    reg ready_downstream;
    reg reset;
    wire [64:0] process_output;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .process_input(process_input),
        .ready_downstream(ready_downstream),
        .reset(reset),
        .process_output(process_output),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            reset = 1;
            process_input = 65'd0;
            ready_downstream = 0;
            @(posedge CLK);
            #1;
            reset = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(65'h0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Normal Processing Condition");
            reset_dut();
            ready_downstream = 1;
            process_input = {1'b0, 64'hFEED_FACE_CAFE_BEEF};
            @(posedge CLK);
            #1;

            #1;


            check_outputs({1'b0, 64'hFEED_FACE_CAFE_BEEF}, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Too Soon Flag (MSB=1)");
            reset_dut();
            ready_downstream = 1;
            process_input = {1'b1, 64'hAAAA_BBBB_CCCC_DDDD};
            @(posedge CLK);
            #1;

            #1;


            check_outputs({1'b1, 64'hAAAA_BBBB_CCCC_DDDD}, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Downstream Not Ready");
            reset_dut();
            ready_downstream = 0;
            process_input = {1'b0, 64'h1111_2222_3333_4444};
            @(posedge CLK);
            #1;

            #1;


            check_outputs({1'b0, 64'h1111_2222_3333_4444}, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Multiple Cycles and Limit Check");
            reset_dut();
            ready_downstream = 1;

            process_input = {1'b0, 64'h1};
            @(posedge CLK); #1;
            process_input = {1'b0, 64'h2};
            @(posedge CLK); #1;
            process_input = {1'b0, 64'h3};
            @(posedge CLK); #1;


            #1;



            check_outputs({1'b0, 64'h3}, 1'b1);
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
        input [64:0] expected_process_output;
        input expected_ready;
        begin
            if (expected_process_output === (expected_process_output ^ process_output ^ expected_process_output) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: process_output=%h, ready=%b",
                         process_output, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: process_output=%h, ready=%b",
                         expected_process_output, expected_ready);
                $display("  Got:      process_output=%h, ready=%b",
                         process_output, ready);
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
        $dumpvars(0,CLK, process_input, ready_downstream, reset, process_output, ready);
    end

endmodule
