`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %03d: All inputs zero", test_num);
        x1 = 8'd0;
        x2 = 8'd0;
        #1;

        check_outputs(16'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %03d: Maximum 8-bit inputs", test_num);
        x1 = 8'd255;
        x2 = 8'd255;
        #1;

        check_outputs(16'd1280);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %03d: x1 active, x2 zero", test_num);
        x1 = 8'd100;
        x2 = 8'd0;
        #1;

        check_outputs(16'd205);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %03d: x1 zero, x2 active", test_num);
        x1 = 8'd0;
        x2 = 8'd100;
        #1;

        check_outputs(16'd305);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %03d: Small values", test_num);
        x1 = 8'd10;
        x2 = 8'd5;
        #1;

        check_outputs(16'd40);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %03d: Mid-range values", test_num);
        x1 = 8'd128;
        x2 = 8'd64;
        #1;

        check_outputs(16'd453);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %03d: Large mixed values", test_num);
        x1 = 8'd200;
        x2 = 8'd150;
        #1;

        check_outputs(16'd855);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("linear_regression Testbench");
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
