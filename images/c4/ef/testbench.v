`timescale 1ns/1ps

module check_1ns_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] time_values;
    wire check;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    check_1ns dut (
        .time_values(time_values),
        .check(check)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Both timeunit and timeprecision set to 1ns", test_num);

            time_values = {16'd1, 16'd1};
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Only timeunit set to 1ns", test_num);

            time_values = {16'd1, 16'd10};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Only timeprecision set to 1ns", test_num);

            time_values = {16'd100, 16'd1};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Both values set to 0", test_num);
            time_values = {16'd0, 16'd0};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Both values set to maximum (65535)", test_num);
            time_values = {16'hFFFF, 16'hFFFF};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Timeunit 1ns, Timeprecision 2ns", test_num);
            time_values = {16'd1, 16'd2};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Timeunit 2ns, Timeprecision 1ns", test_num);
            time_values = {16'd2, 16'd1};
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Re-verifying valid 1ns/1ns configuration", test_num);
            time_values = 32'h0001_0001;
            #1;

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
        $display("check_1ns Testbench");
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
        input expected_check;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_check === (expected_check ^ check ^ expected_check)) begin
                $display("PASS");
                $display("  Outputs: check=%b",
                         check);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: check=%b",
                         expected_check);
                $display("  Got:      check=%b",
                         check);
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
