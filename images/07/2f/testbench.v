`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] m;
    reg [15:0] x;
    wire [31:0] y_prime;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .m(m),
        .x(x),
        .y_prime(y_prime)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Zero inputs", test_num);
        m = 16'd0;
        x = 16'd0;
        #1;

        check_outputs(32'd0 + B_VAL);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Zero slope, non-zero x", test_num);
        m = 16'd0;
        x = 16'd500;
        #1;

        check_outputs(32'd0 + B_VAL);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Non-zero slope, zero x", test_num);
        m = 16'd123;
        x = 16'd0;
        #1;

        check_outputs(32'd0 + B_VAL);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Standard computation (m=5, x=10)", test_num);
        m = 16'd5;
        x = 16'd10;
        #1;

        check_outputs((32'd5 * 32'd10) + B_VAL);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Larger values (m=255, x=100)", test_num);
        m = 16'd255;
        x = 16'd100;
        #1;

        check_outputs((32'd255 * 32'd100) + B_VAL);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: High slope, small x", test_num);
        m = 16'hFFFF;
        x = 16'd2;
        #1;

        check_outputs((32'hFFFF * 32'd2) + B_VAL);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %03d: Maximum input range test", test_num);
        m = 16'hFFFF;
        x = 16'hFFFF;
        #1;

        check_outputs((32'hFFFF * 32'hFFFF) + B_VAL);
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
        input [31:0] expected_y_prime;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y_prime === (expected_y_prime ^ y_prime ^ expected_y_prime)) begin
                $display("PASS");
                $display("  Outputs: y_prime=%h",
                         y_prime);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y_prime=%h",
                         expected_y_prime);
                $display("  Got:      y_prime=%h",
                         y_prime);
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
