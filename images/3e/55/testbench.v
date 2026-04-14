`timescale 1ns/1ps

module pll_2x_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    reg rst_n;
    wire clk_out;
    wire control_voltage;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pll_2x dut (
        .clk_in(clk_in),
        .rst_n(rst_n),
        .clk_out(clk_out),
        .control_voltage(control_voltage)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            rst_n = 0;
            #20;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Reset state check", test_num);
            rst_n = 0;
            #50;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        realtime t1, t2, period;
        reg freq_correct;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Frequency doubling lock check", test_num);
            reset_dut();



            #5000;


            @(posedge clk_out);
            t1 = $realtime;
            @(posedge clk_out);
            t2 = $realtime;
            period = t2 - t1;

            $display("  Measured clk_out period: %0t ns", period);


            if (period >= 4.9 && period <= 5.1) begin
                freq_correct = 1'b1;
            end else begin
                freq_correct = 1'b0;
            end




            if (freq_correct)
                #1;

                check_outputs(clk_out, control_voltage);
            else
                #1;

                check_outputs(!clk_out, control_voltage);
        end
        endtask

    task testcase003;

        reg val_before, val_after;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Control voltage stability check", test_num);
            reset_dut();


            #2000;
            val_before = control_voltage;


            #500;
            val_after = control_voltage;



            if (val_before == val_after)
                #1;

                check_outputs(clk_out, val_after);
            else
                #1;

                check_outputs(clk_out, !val_after);
        end
        endtask

    task testcase004;

        realtime t_pos, t_neg, t_next_pos;
        realtime high_time, low_time;
        reg duty_ok;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Duty cycle check", test_num);
            reset_dut();

            #3000;

            @(posedge clk_out);
            t_pos = $realtime;
            @(negedge clk_out);
            t_neg = $realtime;
            @(posedge clk_out);
            t_next_pos = $realtime;

            high_time = t_neg - t_pos;
            low_time = t_next_pos - t_neg;

            $display("  High time: %0t, Low time: %0t", high_time, low_time);


            if (high_time > 2.0 && high_time < 3.0 && low_time > 2.0 && low_time < 3.0)
                duty_ok = 1'b1;
            else
                duty_ok = 1'b0;

            if (duty_ok)
                #1;

                check_outputs(clk_out, control_voltage);
            else
                #1;

                check_outputs(!clk_out, control_voltage);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pll_2x Testbench");
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
        input expected_clk_out;
        input expected_control_voltage;
        begin
            if (expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out) &&
                expected_control_voltage === (expected_control_voltage ^ control_voltage ^ expected_control_voltage)) begin
                $display("PASS");
                $display("  Outputs: clk_out=%b, control_voltage=%b",
                         clk_out, control_voltage);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_out=%b, control_voltage=%b",
                         expected_clk_out, expected_control_voltage);
                $display("  Got:      clk_out=%b, control_voltage=%b",
                         clk_out, control_voltage);
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
        $dumpvars(0,clk_in, rst_n, clk_out, control_voltage);
    end

endmodule
