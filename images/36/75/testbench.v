`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x0;
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .x0(x0),
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .y(y)
    );
    task testcase001;

        begin
            $display("Test Case 001: All inputs zero");
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Unit inputs (All ones)");
            x0 = 8'd1; x1 = 8'd1; x2 = 8'd1; x3 = 8'd1;

            #1;


            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Impulse response - Tap 0");
            x0 = 8'd1; x1 = 8'd0; x2 = 8'd0; x3 = 8'd0;

            #1;


            check_outputs(16'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Impulse response - Tap 1");
            x0 = 8'd0; x1 = 8'd1; x2 = 8'd0; x3 = 8'd0;

            #1;


            check_outputs(16'd2);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Impulse response - Tap 2");
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd1; x3 = 8'd0;

            #1;


            check_outputs(16'd3);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Impulse response - Tap 3");
            x0 = 8'd0; x1 = 8'd0; x2 = 8'd0; x3 = 8'd1;

            #1;


            check_outputs(16'd4);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Arbitrary weighted values");
            x0 = 8'd10; x1 = 8'd20; x2 = 8'd30; x3 = 8'd40;

            #1;


            check_outputs(16'd300);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Maximum input values");
            x0 = 8'd255; x1 = 8'd255; x2 = 8'd255; x3 = 8'd255;

            #1;


            check_outputs(16'd2550);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Staggered values");
            x0 = 8'd5; x1 = 8'd4; x2 = 8'd3; x3 = 8'd2;

            #1;


            check_outputs(16'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [15:0] expected_y;
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
