`timescale 1ns/1ps

module TemperatureSensorController_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg read;
    reg reset;
    reg [2:0] temperature;
    wire alarm;
    wire [1:0] state;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TemperatureSensorController dut (
        .clk(clk),
        .read(read),
        .reset(reset),
        .temperature(temperature),
        .alarm(alarm),
        .state(state)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            read = 0;
            temperature = 0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
            test_num = test_num + 1;
        end
        endtask
    task testcase001;

        begin
            $display("Test Case 001: Temp=2 (Below Threshold)");
            reset_dut();


            read = 1;
            temperature = 3'd2;
            @(posedge clk);

            read = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(0, 2'b10);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Temp=6 (Above Threshold)");
            reset_dut();

            read = 1;
            temperature = 3'd6;
            @(posedge clk);

            read = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Temp=4 (Boundary Condition)");
            reset_dut();

            read = 1;
            temperature = 3'd4;
            @(posedge clk);

            read = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(0, 2'b10);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Temp=7 (Maximum Value)");
            reset_dut();

            read = 1;
            temperature = 3'd7;
            @(posedge clk);

            read = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1, 2'b10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Temp=0 (Minimum Value)");
            reset_dut();

            read = 1;
            temperature = 3'd0;
            @(posedge clk);

            read = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(0, 2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Verify Return to IDLE");
            reset_dut();

            read = 1;
            temperature = 3'd5;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);

            #1;
            #1;

            check_outputs(0, 2'b00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TemperatureSensorController Testbench");
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
        input expected_alarm;
        input [1:0] expected_state;
        begin
            if (expected_alarm === (expected_alarm ^ alarm ^ expected_alarm) &&
                expected_state === (expected_state ^ state ^ expected_state)) begin
                $display("PASS");
                $display("  Outputs: alarm=%b, state=%h",
                         alarm, state);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: alarm=%b, state=%h",
                         expected_alarm, expected_state);
                $display("  Got:      alarm=%b, state=%h",
                         alarm, state);
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
        $dumpvars(0,clk, read, reset, temperature, alarm, state);
    end

endmodule
