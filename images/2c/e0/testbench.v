`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] x;
    wire [9:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .a(a),
        .b(b),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Basic calculation (2*10 + 5)");
            a = 8'd2;
            x = 8'd10;
            b = 8'd5;
            #1;

            check_outputs(10'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Zero coefficient a (0*255 + 100)");
            a = 8'd0;
            x = 8'd255;
            b = 8'd100;
            #1;

            check_outputs(10'd100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Zero input x (255*0 + 50)");
            a = 8'd255;
            x = 8'd0;
            b = 8'd50;
            #1;

            check_outputs(10'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Zero offset b (3*200 + 0)");
            a = 8'd3;
            x = 8'd200;
            b = 8'd0;
            #1;

            check_outputs(10'd600);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: All zeros");
            a = 8'd0;
            x = 8'd0;
            b = 8'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Maximum b with a=1 (1*255 + 255)");
            a = 8'd1;
            x = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(10'd510);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Result approaching 10-bit limit (4*250 + 20)");
            a = 8'd4;
            x = 8'd250;
            b = 8'd20;
            #1;

            check_outputs(10'd1020);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Maximum possible 10-bit result (4*255 + 3)");
            a = 8'd4;
            x = 8'd255;
            b = 8'd3;
            #1;

            check_outputs(10'd1023);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Small values (1*1 + 1)");
            a = 8'd1;
            x = 8'd1;
            b = 8'd1;
            #1;

            check_outputs(10'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Standard regression point (2*255 + 255)");
            a = 8'd2;
            x = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(10'd765);
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
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [9:0] expected_y;
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
