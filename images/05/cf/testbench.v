`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg [15:0] m;
    reg [15:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .m(m),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All inputs zero", test_num);
            m = 16'd0;
            x = 16'd0;
            b = 16'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Zero slope (m=0), output should be b", test_num);
            m = 16'd0;
            x = 16'd1234;
            b = 16'd5678;
            #1;

            check_outputs(32'd5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Zero intercept (b=0), output should be m*x", test_num);
            m = 16'd10;
            x = 16'd25;
            b = 16'd0;
            #1;

            check_outputs(32'd250);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Identity slope (m=1) and b=0", test_num);
            m = 16'd1;
            x = 16'd999;
            b = 16'd0;
            #1;

            check_outputs(32'd999);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Typical calculation (m=12, x=34, b=56)", test_num);
            m = 16'd12;
            x = 16'd34;
            b = 16'd56;

            #1;


            check_outputs(32'd464);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Large values resulting in >16-bit product", test_num);
            m = 16'd1000;
            x = 16'd1000;
            b = 16'd1;

            #1;


            check_outputs(32'd1000001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Max slope and Max x with b=0", test_num);
            m = 16'hFFFF;
            x = 16'hFFFF;
            b = 16'h0000;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Max slope, Max x, and Max b", test_num);
            m = 16'hFFFF;
            x = 16'hFFFF;
            b = 16'hFFFF;

            #1;


            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Small slope, large x", test_num);
            m = 16'd2;
            x = 16'h8000;
            b = 16'd10;

            #1;


            check_outputs(32'd65546);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Intercept at max 16-bit value", test_num);
            m = 16'd5;
            x = 16'd5;
            b = 16'hFFFF;

            #1;


            check_outputs(32'd65560);
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
        input [31:0] expected_y;
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
