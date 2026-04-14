`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bcd_ht;
    reg [3:0] bcd_hu;
    reg day_night;
    wire [3:0] bcd_hto;
    wire [3:0] bcd_huo;
    wire day;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bcd_ht(bcd_ht),
        .bcd_hu(bcd_hu),
        .day_night(day_night),
        .bcd_hto(bcd_hto),
        .bcd_huo(bcd_huo),
        .day(day)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h1; bcd_hu = 4'h2; day_night = 0;
        $display("Test %0d: 12:00 AM (Midnight)", test_num);
        #1;

        check_outputs(4'h0, 4'h0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h0; bcd_hu = 4'h1; day_night = 0;
        $display("Test %0d: 01:00 AM", test_num);
        #1;

        check_outputs(4'h0, 4'h1, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h1; bcd_hu = 4'h0; day_night = 0;
        $display("Test %0d: 10:00 AM", test_num);
        #1;

        check_outputs(4'h1, 4'h0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h1; bcd_hu = 4'h1; day_night = 0;
        $display("Test %0d: 11:00 AM", test_num);
        #1;

        check_outputs(4'h1, 4'h1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h1; bcd_hu = 4'h2; day_night = 1;
        $display("Test %0d: 12:00 PM (Noon)", test_num);
        #1;

        check_outputs(4'h1, 4'h2, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h0; bcd_hu = 4'h1; day_night = 1;
        $display("Test %0d: 01:00 PM", test_num);
        #1;

        check_outputs(4'h1, 4'h3, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h0; bcd_hu = 4'h8; day_night = 1;
        $display("Test %0d: 08:00 PM", test_num);
        #1;

        check_outputs(4'h2, 4'h0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        bcd_ht = 4'h1; bcd_hu = 4'h1; day_night = 1;
        $display("Test %0d: 11:00 PM", test_num);
        #1;

        check_outputs(4'h2, 4'h3, 1);
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
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_bcd_hto;
        input [3:0] expected_bcd_huo;
        input expected_day;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_hto === (expected_bcd_hto ^ bcd_hto ^ expected_bcd_hto) &&
                expected_bcd_huo === (expected_bcd_huo ^ bcd_huo ^ expected_bcd_huo) &&
                expected_day === (expected_day ^ day ^ expected_day)) begin
                $display("PASS");
                $display("  Outputs: bcd_hto=%h, bcd_huo=%h, day=%b",
                         bcd_hto, bcd_huo, day);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_hto=%h, bcd_huo=%h, day=%b",
                         expected_bcd_hto, expected_bcd_huo, expected_day);
                $display("  Got:      bcd_hto=%h, bcd_huo=%h, day=%b",
                         bcd_hto, bcd_huo, day);
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

endmodule
