`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] control;
    reg [2:0] control_l_r;
    reg [5:0] counter_neg;
    reg is_control;
    reg last_is_control;
    reg posedge_clk;
    reg rx_error_c;
    reg rx_error_d;
    reg rx_resetn;
    wire ready_control_p_r;
    wire ready_data_p_r;
    wire rx_error;
    wire rx_got_fct_fsm;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .control_l_r(control_l_r),
        .counter_neg(counter_neg),
        .is_control(is_control),
        .last_is_control(last_is_control),
        .posedge_clk(posedge_clk),
        .rx_error_c(rx_error_c),
        .rx_error_d(rx_error_d),
        .rx_resetn(rx_resetn),
        .ready_control_p_r(ready_control_p_r),
        .ready_data_p_r(ready_data_p_r),
        .rx_error(rx_error),
        .rx_got_fct_fsm(rx_got_fct_fsm)
    );

    // Clock generation (10ns period)
    initial begin
        posedge_clk = 0;
        forever #5 posedge_clk = ~posedge_clk;
    end

        task reset_dut;

        begin
            rx_resetn = 0;
            control = 3'b000;
            control_l_r = 3'b000;
            counter_neg = 6'b000000;
            is_control = 0;
            last_is_control = 0;
            rx_error_c = 0;
            rx_error_d = 0;
            @(posedge posedge_clk);
            #1;
            rx_resetn = 1;
            @(posedge posedge_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: System Reset Initialization", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Control Readiness Signal", test_num);
            reset_dut();
            is_control = 1;
            counter_neg = 6'd1;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Data Readiness Signal", test_num);
            reset_dut();
            is_control = 0;
            last_is_control = 1;
            counter_neg = 6'd1;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Control Error Detection", test_num);
            reset_dut();
            rx_error_c = 1;
            @(posedge posedge_clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Data Error Detection", test_num);
            reset_dut();
            rx_error_d = 1;
            @(posedge posedge_clk);
            #1;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: FCT Detection FSM", test_num);
            reset_dut();
            is_control = 1;
            control = 3'b100;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Counter Timing Logic", test_num);
            reset_dut();
            counter_neg = 6'b000000;
            is_control = 1;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(1, 0, 0, 0);
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
        testcase007();
        
        
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
        input expected_ready_control_p_r;
        input expected_ready_data_p_r;
        input expected_rx_error;
        input expected_rx_got_fct_fsm;
        begin
            if (expected_ready_control_p_r === (expected_ready_control_p_r ^ ready_control_p_r ^ expected_ready_control_p_r) &&
                expected_ready_data_p_r === (expected_ready_data_p_r ^ ready_data_p_r ^ expected_ready_data_p_r) &&
                expected_rx_error === (expected_rx_error ^ rx_error ^ expected_rx_error) &&
                expected_rx_got_fct_fsm === (expected_rx_got_fct_fsm ^ rx_got_fct_fsm ^ expected_rx_got_fct_fsm)) begin
                $display("PASS");
                $display("  Outputs: ready_control_p_r=%b, ready_data_p_r=%b, rx_error=%b, rx_got_fct_fsm=%b",
                         ready_control_p_r, ready_data_p_r, rx_error, rx_got_fct_fsm);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready_control_p_r=%b, ready_data_p_r=%b, rx_error=%b, rx_got_fct_fsm=%b",
                         expected_ready_control_p_r, expected_ready_data_p_r, expected_rx_error, expected_rx_got_fct_fsm);
                $display("  Got:      ready_control_p_r=%b, ready_data_p_r=%b, rx_error=%b, rx_got_fct_fsm=%b",
                         ready_control_p_r, ready_data_p_r, rx_error, rx_got_fct_fsm);
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
        $dumpvars(0,control, control_l_r, counter_neg, is_control, last_is_control, posedge_clk, rx_error_c, rx_error_d, rx_resetn, ready_control_p_r, ready_data_p_r, rx_error, rx_got_fct_fsm);
    end

endmodule
