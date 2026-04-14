`timescale 1ns/1ps

module chebyshev_filter_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] x;
    wire [4:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chebyshev_filter dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Zero Input (DC)");

        x = 5'd0;
        #10;
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Mid-scale Input (DC)");

        x = 5'd16;
        #10;
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Full-scale Input (DC)");

        x = 5'd31;
        #10;
        #1;

        check_outputs(5'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Small Signal Magnitude");

        x = 5'd4;
        #10;
        #1;

        check_outputs(5'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Upper-mid Range Signal");

        x = 5'd22;
        #10;
        #1;

        check_outputs(5'd22);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Step Transition Test");



        x = 5'd30;
        #10;
        x = 5'd10;
        #20;
        #1;

        check_outputs(5'd10);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chebyshev_filter Testbench");
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
        input [4:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
