`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg control_signal;
    reg [3:0] current_value;
    wire alert;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .control_signal(control_signal),
        .current_value(current_value),
        .alert(alert)
    );

    // Clock generation (10ns period)
    initial begin
        control_signal = 0;
        forever #5 control_signal = ~control_signal;
    end

        task reset_dut;

    begin


        current_value = 4'b0000;
        @(negedge control_signal);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Current below threshold (Val=3, Threshold=5)", test_num);
        current_value = 4'd3;

        @(posedge control_signal);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Current above threshold (Val=8, Threshold=5)", test_num);
        current_value = 4'd8;
        @(posedge control_signal);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Current exactly at threshold (Val=5, Threshold=5)", test_num);
        current_value = 4'd5;
        @(posedge control_signal);
        #2;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Current at maximum value (Val=15, Threshold=5)", test_num);
        current_value = 4'd15;
        @(posedge control_signal);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Current at zero (Val=0, Threshold=5)", test_num);
        current_value = 4'd0;
        @(posedge control_signal);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test Case %03d: Sequential change from High to Low current", test_num);


        current_value = 4'd10;
        @(posedge control_signal);


        @(negedge control_signal);
        current_value = 4'd2;
        @(posedge control_signal);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("current_sensor Testbench");
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
        input expected_alert;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert)) begin
                $display("PASS");
                $display("  Outputs: alert=%b",
                         alert);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b",
                         expected_alert);
                $display("  Got:      alert=%b",
                         alert);
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
        $dumpvars(0,control_signal, current_value, alert);
    end

endmodule
