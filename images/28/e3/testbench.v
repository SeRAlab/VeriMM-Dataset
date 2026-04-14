`timescale 1ns/1ps

module temperature_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [9:0] temp_in;
    wire alert;
    wire [9:0] last_temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temperature_sensor dut (
        .clk(clk),
        .reset(reset),
        .temp_in(temp_in),
        .alert(alert),
        .last_temp(last_temp)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temp_in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Reset State Initialization");
            reset_dut();

            #1;


            check_outputs(1'b0, 10'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Temp 50 (Below Threshold)");
            reset_dut();
            temp_in = 10'd50;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 10'd50);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Temp 75 (Boundary - Should not trigger)");
            reset_dut();
            temp_in = 10'd75;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 10'd75);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Temp 76 (Above Threshold - Should trigger)");
            reset_dut();
            temp_in = 10'd76;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 10'd76);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Max Temp 1023");
            reset_dut();
            temp_in = 10'd1023;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 10'd1023);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Transition from High to Low Temp");
            reset_dut();

            temp_in = 10'd100;
            @(posedge clk);
            #1;

            temp_in = 10'd20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 10'd20);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temperature_sensor Testbench");
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
        input [9:0] expected_last_temp;
        begin
            if (expected_alert === (expected_alert ^ alert ^ expected_alert) &&
                expected_last_temp === (expected_last_temp ^ last_temp ^ expected_last_temp)) begin
                $display("PASS");
                $display("  Outputs: alert=%b, last_temp=%h",
                         alert, last_temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alert=%b, last_temp=%h",
                         expected_alert, expected_last_temp);
                $display("  Got:      alert=%b, last_temp=%h",
                         alert, last_temp);
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
        $dumpvars(0,clk, reset, temp_in, alert, last_temp);
    end

endmodule
