`timescale 1ns/1ps

module current_sensor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] current_value;
    reg reset;
    wire exceeds_threshold;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    current_sensor dut (
        .clk(clk),
        .current_value(current_value),
        .reset(reset),
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
            current_value = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Value below threshold (10'd100)");
            current_value = 10'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Value above threshold (10'd800)");
            current_value = 10'd800;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Boundary value (Exactly 10'd500)");
            current_value = 10'd500;
            @(posedge clk);

            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Boundary value (10'd501)");
            current_value = 10'd501;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Minimum value (10'd0)");
            current_value = 10'd0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Maximum value (10'd1023)");
            current_value = 10'd1023;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
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
        $dumpvars(0,clk, current_value, reset, exceeds_threshold);
    end

endmodule
