`timescale 1ns/1ps

module digital_clock_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    wire [4:0] hours;
    wire [5:0] minutes;
    wire [5:0] seconds;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    digital_clock dut (
        .clk(clk),
        .reset(reset),
        .hours(hours),
        .minutes(minutes),
        .seconds(seconds)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset and count 10 seconds", test_num);
            reset_dut();
            repeat(10) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 6'd0, 6'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Seconds to Minutes rollover (60s)", test_num);
            reset_dut();
            repeat(60) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 6'd1, 6'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Minutes to Hours rollover (3600s)", test_num);
            reset_dut();
            repeat(3600) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 6'd0, 6'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify 01:01:01 (3661s)", test_num);
            reset_dut();
            repeat(3661) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd1, 6'd1, 6'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 24-hour rollover (86400s)", test_num);
            reset_dut();
            repeat(86400) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd0, 6'd0, 6'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max time 23:59:59 (86399s)", test_num);
            reset_dut();
            repeat(86399) @(posedge clk);
            #1;
            #1;

            check_outputs(5'd23, 6'd59, 6'd59);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("digital_clock Testbench");
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
        input [4:0] expected_hours;
        input [5:0] expected_minutes;
        input [5:0] expected_seconds;
        begin
            if (expected_hours === (expected_hours ^ hours ^ expected_hours) &&
                expected_minutes === (expected_minutes ^ minutes ^ expected_minutes) &&
                expected_seconds === (expected_seconds ^ seconds ^ expected_seconds)) begin
                $display("PASS");
                $display("  Outputs: hours=%h, minutes=%h, seconds=%h",
                         hours, minutes, seconds);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hours=%h, minutes=%h, seconds=%h",
                         expected_hours, expected_minutes, expected_seconds);
                $display("  Got:      hours=%h, minutes=%h, seconds=%h",
                         hours, minutes, seconds);
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
        $dumpvars(0,clk, reset, hours, minutes, seconds);
    end

endmodule
