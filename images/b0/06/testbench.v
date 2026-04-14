`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] hours;
    wire am_pm;
    wire [7:0] twelve_hour_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hours(hours),
        .am_pm(am_pm),
        .twelve_hour_out(twelve_hour_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 0 (Midnight)", test_num);
            hours = 8'd0;
            #1;

            check_outputs(1'b0, 8'd12);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 1", test_num);
            hours = 8'd1;
            #1;

            check_outputs(1'b0, 8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 11", test_num);
            hours = 8'd11;
            #1;

            check_outputs(1'b0, 8'd11);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 12 (Noon)", test_num);
            hours = 8'd12;
            #1;

            check_outputs(1'b1, 8'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 13", test_num);
            hours = 8'd13;
            #1;

            check_outputs(1'b1, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 18", test_num);
            hours = 8'd18;
            #1;

            check_outputs(1'b1, 8'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hour 23", test_num);
            hours = 8'd23;
            #1;

            check_outputs(1'b1, 8'd11);
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
        input expected_am_pm;
        input [7:0] expected_twelve_hour_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_am_pm === (expected_am_pm ^ am_pm ^ expected_am_pm) &&
                expected_twelve_hour_out === (expected_twelve_hour_out ^ twelve_hour_out ^ expected_twelve_hour_out)) begin
                $display("PASS");
                $display("  Outputs: am_pm=%b, twelve_hour_out=%h",
                         am_pm, twelve_hour_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: am_pm=%b, twelve_hour_out=%h",
                         expected_am_pm, expected_twelve_hour_out);
                $display("  Got:      am_pm=%b, twelve_hour_out=%h",
                         am_pm, twelve_hour_out);
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
