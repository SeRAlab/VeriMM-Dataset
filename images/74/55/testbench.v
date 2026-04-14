`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg last_is_control;
    reg last_is_data;
    reg last_is_timec;
    reg posedge_clk;
    reg rx_resetn;
    wire rx_got_nchar;
    wire rx_got_null;
    wire rx_got_time_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .last_is_control(last_is_control),
        .last_is_data(last_is_data),
        .last_is_timec(last_is_timec),
        .posedge_clk(posedge_clk),
        .rx_resetn(rx_resetn),
        .rx_got_nchar(rx_got_nchar),
        .rx_got_null(rx_got_null),
        .rx_got_time_code(rx_got_time_code)
    );

    // Clock generation (10ns period)
    initial begin
        posedge_clk = 0;
        forever #5 posedge_clk = ~posedge_clk;
    end

        task reset_dut;

        begin
            rx_resetn = 0;
            last_is_control = 0;
            last_is_data = 0;
            last_is_timec = 0;
            repeat (2) @(posedge posedge_clk);
            #1;
            rx_resetn = 1;
            @(posedge posedge_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: N-Char Detection", test_num);
            reset_dut();
            last_is_data = 1;
            @(posedge posedge_clk);
            #1;
            last_is_data = 0;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: NULL Detection", test_num);
            reset_dut();
            last_is_control = 1;
            @(posedge posedge_clk);
            #1;
            last_is_control = 0;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Time-Code Detection", test_num);
            reset_dut();
            last_is_timec = 1;
            @(posedge posedge_clk);
            #1;
            last_is_timec = 0;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle State (No inputs)", test_num);
            reset_dut();
            repeat (3) @(posedge posedge_clk);
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Detection (Data then Control)", test_num);
            reset_dut();


            last_is_data = 1;
            @(posedge posedge_clk);
            #1;
            last_is_data = 0;
            last_is_control = 1;
            @(posedge posedge_clk);
            #1;
            last_is_control = 0;
            @(posedge posedge_clk);
            #1;





            #1;






            check_outputs(0, 1, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during active input", test_num);
            reset_dut();
            last_is_data = 1;
            @(posedge posedge_clk);
            #1;
            rx_resetn = 0;
            @(posedge posedge_clk);
            #1;
            rx_resetn = 1;
            last_is_data = 0;
            @(posedge posedge_clk);
            #1;

            #1;


            check_outputs(0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid Time-Code pulse", test_num);
            reset_dut();
            last_is_timec = 1;
            @(posedge posedge_clk);
            #1;
            last_is_timec = 0;
            @(posedge posedge_clk);
            #1;
            #1;

            check_outputs(0, 0, 1);
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
        testcase008();
        
        
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
        input expected_rx_got_nchar;
        input expected_rx_got_null;
        input expected_rx_got_time_code;
        begin
            if (expected_rx_got_nchar === (expected_rx_got_nchar ^ rx_got_nchar ^ expected_rx_got_nchar) &&
                expected_rx_got_null === (expected_rx_got_null ^ rx_got_null ^ expected_rx_got_null) &&
                expected_rx_got_time_code === (expected_rx_got_time_code ^ rx_got_time_code ^ expected_rx_got_time_code)) begin
                $display("PASS");
                $display("  Outputs: rx_got_nchar=%b, rx_got_null=%b, rx_got_time_code=%b",
                         rx_got_nchar, rx_got_null, rx_got_time_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_got_nchar=%b, rx_got_null=%b, rx_got_time_code=%b",
                         expected_rx_got_nchar, expected_rx_got_null, expected_rx_got_time_code);
                $display("  Got:      rx_got_nchar=%b, rx_got_null=%b, rx_got_time_code=%b",
                         rx_got_nchar, rx_got_null, rx_got_time_code);
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
        $dumpvars(0,last_is_control, last_is_data, last_is_timec, posedge_clk, rx_resetn, rx_got_nchar, rx_got_null, rx_got_time_code);
    end

endmodule
