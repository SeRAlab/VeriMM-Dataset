`timescale 1ns/1ps

module temp_shutdown_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] temp_reading;
    reg [3:0] threshold;
    wire shutdown_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    temp_shutdown dut (
        .clk(clk),
        .reset(reset),
        .temp_reading(temp_reading),
        .threshold(threshold),
        .shutdown_signal(shutdown_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            temp_reading = 0;
            threshold = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Temp < Threshold (Normal Operation)", test_num);
            reset_dut();
            temp_reading = 4'd5;
            threshold = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Temp > Threshold (Shutdown Triggered)", test_num);
            reset_dut();
            temp_reading = 4'd12;
            threshold = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Temp == Threshold (Boundary Condition)", test_num);
            reset_dut();
            temp_reading = 4'd7;
            threshold = 4'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Max Temp, Min Threshold", test_num);
            reset_dut();
            temp_reading = 4'd15;
            threshold = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Min Temp, Max Threshold", test_num);
            reset_dut();
            temp_reading = 4'd0;
            threshold = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Reset during active shutdown", test_num);
            reset_dut();
            temp_reading = 4'd15;
            threshold = 4'd5;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1;
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
        $display("temp_shutdown Testbench");
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
        input expected_shutdown_signal;
        begin
            if (expected_shutdown_signal === (expected_shutdown_signal ^ shutdown_signal ^ expected_shutdown_signal)) begin
                $display("PASS");
                $display("  Outputs: shutdown_signal=%b",
                         shutdown_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: shutdown_signal=%b",
                         expected_shutdown_signal);
                $display("  Got:      shutdown_signal=%b",
                         shutdown_signal);
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
        $dumpvars(0,clk, reset, temp_reading, threshold, shutdown_signal);
    end

endmodule
