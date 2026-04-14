`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] control;
    reg last_is_control;
    reg last_is_data;
    reg last_is_timec;
    reg negedge_clk;
    reg rx_resetn;
    reg [1:0] state_data_process;
    wire rx_buffer_write;
    wire rx_tick_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .last_is_control(last_is_control),
        .last_is_data(last_is_data),
        .last_is_timec(last_is_timec),
        .negedge_clk(negedge_clk),
        .rx_resetn(rx_resetn),
        .state_data_process(state_data_process),
        .rx_buffer_write(rx_buffer_write),
        .rx_tick_out(rx_tick_out)
    );

    // Clock generation (10ns period)
    initial begin
        negedge_clk = 0;
        forever #5 negedge_clk = ~negedge_clk;
    end

        task reset_dut;

        begin
            @(negedge negedge_clk);
            rx_resetn = 0;
            state_data_process = 2'b00;
            control = 3'b000;
            last_is_control = 0;
            last_is_data = 0;
            last_is_timec = 0;
            @(negedge negedge_clk);
            rx_resetn = 1;
            @(negedge negedge_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Post-Reset Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Valid Data Write Condition", test_num);
            reset_dut();
            state_data_process = 2'b01;
            last_is_data = 1;
            control = 3'b001;
            @(negedge negedge_clk);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Valid Time Write Condition", test_num);
            reset_dut();
            state_data_process = 2'b10;
            last_is_timec = 1;
            @(negedge negedge_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Valid Control Write Condition", test_num);
            reset_dut();
            state_data_process = 2'b11;
            last_is_control = 1;
            @(negedge negedge_clk);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Idle State with Flags High", test_num);
            reset_dut();
            state_data_process = 2'b00;
            last_is_data = 1;
            last_is_timec = 1;
            @(negedge negedge_clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset Dominance during valid flags", test_num);
            reset_dut();
            state_data_process = 2'b01;
            last_is_data = 1;
            rx_resetn = 0;
            @(negedge negedge_clk);
            #1;

            check_outputs(1'b0, 1'b0);
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
        input expected_rx_buffer_write;
        input expected_rx_tick_out;
        begin
            if (expected_rx_buffer_write === (expected_rx_buffer_write ^ rx_buffer_write ^ expected_rx_buffer_write) &&
                expected_rx_tick_out === (expected_rx_tick_out ^ rx_tick_out ^ expected_rx_tick_out)) begin
                $display("PASS");
                $display("  Outputs: rx_buffer_write=%b, rx_tick_out=%b",
                         rx_buffer_write, rx_tick_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_buffer_write=%b, rx_tick_out=%b",
                         expected_rx_buffer_write, expected_rx_tick_out);
                $display("  Got:      rx_buffer_write=%b, rx_tick_out=%b",
                         rx_buffer_write, rx_tick_out);
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
        $dumpvars(0,control, last_is_control, last_is_data, last_is_timec, negedge_clk, rx_resetn, state_data_process, rx_buffer_write, rx_tick_out);
    end

endmodule
