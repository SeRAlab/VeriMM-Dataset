`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add;
    reg set_hour;
    reg set_minute;
    wire [3:0] hour1;
    wire [3:0] hour2;
    wire [3:0] minute1;
    wire [3:0] minute2;
    wire [3:0] second1;
    wire [3:0] second2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add(add),
        .set_hour(set_hour),
        .set_minute(set_minute),
        .hour1(hour1),
        .hour2(hour2),
        .minute1(minute1),
        .minute2(minute2),
        .second1(second1),
        .second2(second2)
    );

    // Clock generation (10ns period)
    initial begin
        add = 0;
        forever #5 add = ~add;
    end

        task reset_dut;

        begin
            set_hour = 0;
            set_minute = 0;


            repeat(2) @(negedge add);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment minute by 1", test_num);

            set_minute = 1;
            @(negedge add);
            set_minute = 0;
            #1;
            #1;

            check_outputs(4'd2, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment minute to 59", test_num);

            repeat(58) begin
                set_minute = 1;
                @(negedge add);
            end
            set_minute = 0;
            #1;
            #1;

            check_outputs(4'd2, 4'd1, 4'd9, 4'd5, 4'd0, 4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minute rollover 59->00", test_num);
            set_minute = 1;
            @(negedge add);
            set_minute = 0;
            #1;
            #1;

            check_outputs(4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hour rollover 12->01", test_num);
            set_hour = 1;
            @(negedge add);
            set_hour = 0;
            #1;
            #1;

            check_outputs(4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Cycle hour back to 12", test_num);

            repeat(11) begin
                set_hour = 1;
                @(negedge add);
            end
            set_hour = 0;
            #1;
            #1;

            check_outputs(4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Set time to 10:30", test_num);

            repeat(10) begin
                set_hour = 1;
                @(negedge add);
            end
            set_hour = 0;

            repeat(30) begin
                set_minute = 1;
                @(negedge add);
            end
            set_minute = 0;
            #1;
            #1;

            check_outputs(4'd0, 4'd1, 4'd0, 4'd3, 4'd0, 4'd0);
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
        input [3:0] expected_hour1;
        input [3:0] expected_hour2;
        input [3:0] expected_minute1;
        input [3:0] expected_minute2;
        input [3:0] expected_second1;
        input [3:0] expected_second2;
        begin
            if (expected_hour1 === (expected_hour1 ^ hour1 ^ expected_hour1) &&
                expected_hour2 === (expected_hour2 ^ hour2 ^ expected_hour2) &&
                expected_minute1 === (expected_minute1 ^ minute1 ^ expected_minute1) &&
                expected_minute2 === (expected_minute2 ^ minute2 ^ expected_minute2) &&
                expected_second1 === (expected_second1 ^ second1 ^ expected_second1) &&
                expected_second2 === (expected_second2 ^ second2 ^ expected_second2)) begin
                $display("PASS");
                $display("  Outputs: hour1=%h, hour2=%h, minute1=%h, minute2=%h, second1=%h, second2=%h",
                         hour1, hour2, minute1, minute2, second1, second2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hour1=%h, hour2=%h, minute1=%h, minute2=%h, second1=%h, second2=%h",
                         expected_hour1, expected_hour2, expected_minute1, expected_minute2, expected_second1, expected_second2);
                $display("  Got:      hour1=%h, hour2=%h, minute1=%h, minute2=%h, second1=%h, second2=%h",
                         hour1, hour2, minute1, minute2, second1, second2);
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
        $dumpvars(0,add, set_hour, set_minute, hour1, hour2, minute1, minute2, second1, second2);
    end

endmodule
