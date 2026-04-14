`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] state;
    wire counter_en;
    wire load_en;
    wire local_rst;
    wire mic_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .state(state),
        .counter_en(counter_en),
        .load_en(load_en),
        .local_rst(local_rst),
        .mic_en(mic_en)
    );
    task testcase001;

        begin
            test_num = 1;
            state = 2'b00;
            #10;
            $display("Test Case 001: State 0 (Reset System)");

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            state = 2'b01;
            #10;
            $display("Test Case 002: State 1 (Process Data Mode)");

            #1;


            check_outputs(1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            state = 2'b10;
            #10;
            $display("Test Case 003: State 2 (Specific Operational Mode)");

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            state = 2'b11;
            #10;
            $display("Test Case 004: State 3 (Undefined State Handling)");


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            state = 2'b01;
            #10;
            state = 2'b00;
            #10;
            $display("Test Case 005: Transition State 1 -> State 0");
            #1;

            check_outputs(1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_counter_en;
        input expected_load_en;
        input expected_local_rst;
        input expected_mic_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_counter_en === (expected_counter_en ^ counter_en ^ expected_counter_en) &&
                expected_load_en === (expected_load_en ^ load_en ^ expected_load_en) &&
                expected_local_rst === (expected_local_rst ^ local_rst ^ expected_local_rst) &&
                expected_mic_en === (expected_mic_en ^ mic_en ^ expected_mic_en)) begin
                $display("PASS");
                $display("  Outputs: counter_en=%b, load_en=%b, local_rst=%b, mic_en=%b",
                         counter_en, load_en, local_rst, mic_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_en=%b, load_en=%b, local_rst=%b, mic_en=%b",
                         expected_counter_en, expected_load_en, expected_local_rst, expected_mic_en);
                $display("  Got:      counter_en=%b, load_en=%b, local_rst=%b, mic_en=%b",
                         counter_en, load_en, local_rst, mic_en);
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
