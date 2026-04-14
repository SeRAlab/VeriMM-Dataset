`timescale 1ns/1ps

module temp_sensor_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [4:0] temp_input;
    wire exceeds_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_sensor_controller dut (
        .clk(clk),
        .reset(reset),
        .temp_input(temp_input),
        .exceeds_threshold(exceeds_threshold)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temp_input = 0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Minimum boundary (0 degrees)");
            reset_dut();
            temp_input = 5'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Threshold boundary - Equal (25 degrees)");
            reset_dut();
            temp_input = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Threshold boundary - Just over (26 degrees)");
            reset_dut();
            temp_input = 5'd26;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Maximum boundary (31 degrees)");
            reset_dut();
            temp_input = 5'd31;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Mid-range value below threshold (10 degrees)");
            reset_dut();
            temp_input = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Asynchronous Reset Check");
            reset_dut();
            temp_input = 5'd30;
            @(posedge clk);
            #1;

            if (exceeds_threshold !== 1'b1) $display("Pre-reset check failed");


            reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("temp_sensor_controller Testbench");
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
        input expected_exceeds_threshold;
        begin
            if (expected_exceeds_threshold === (expected_exceeds_threshold ^ exceeds_threshold ^ expected_exceeds_threshold)) begin
                $display("PASS");
                $display("  Outputs: exceeds_threshold=%b",
                         exceeds_threshold);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exceeds_threshold=%b",
                         expected_exceeds_threshold);
                $display("  Got:      exceeds_threshold=%b",
                         exceeds_threshold);
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
        $dumpvars(0,clk, reset, temp_input, exceeds_threshold);
    end

endmodule
