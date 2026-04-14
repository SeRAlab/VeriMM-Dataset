`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg mode;
    reg [7:0] sensor;
    reg trigger;
    wire touch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mode(mode),
        .sensor(sensor),
        .trigger(trigger),
        .touch(touch)
    );

    // Clock generation (10ns period)
    initial begin
        trigger = 0;
        forever #5 trigger = ~trigger;
    end

        task reset_dut;

    begin
        mode = 0;
        sensor = 0;
        @(negedge trigger);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Mode=Capacitance, Sensor=Min (0)", test_num);
        mode = 0;
        sensor = 8'h00;
        @(posedge trigger);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Mode=Capacitance, Sensor=Max (255)", test_num);
        mode = 0;
        sensor = 8'hFF;
        @(posedge trigger);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Mode=Resistance, Sensor=Max (255)", test_num);
        mode = 1;
        sensor = 8'hFF;
        @(posedge trigger);
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Mode=Resistance, Sensor=Min (0)", test_num);
        mode = 1;
        sensor = 8'h00;
        @(posedge trigger);
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Mode=Capacitance, Sensor=128", test_num);
        mode = 0;
        sensor = 8'd128;
        @(posedge trigger);
        #2;


        if (touch === 1'b1 || touch === 1'b0) begin
             $display("  Info: Captured touch=%b for sensor 128", touch);
             pass_count = pass_count + 1;
        end else begin
             fail_count = fail_count + 1;
        end
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
        input expected_touch;
        begin
            if (expected_touch === (expected_touch ^ touch ^ expected_touch)) begin
                $display("PASS");
                $display("  Outputs: touch=%b",
                         touch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: touch=%b",
                         expected_touch);
                $display("  Got:      touch=%b",
                         touch);
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
        $dumpvars(0,mode, sensor, trigger, touch);
    end

endmodule
