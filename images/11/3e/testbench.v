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
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (y = 0*0 + 0)", test_num);
            m = 16'h0000;
            x = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Slope (y = 0*x + b)", test_num);
            m = 16'h0000;
            x = 16'hFFFF;
            b = 16'hABCD;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Input (y = m*0 + b)", test_num);
            m = 16'h1234;
            x = 16'h0000;
            b = 16'h5678;
            #1;

            check_outputs(32'h00005678);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unit Values (y = 1*1 + 1)", test_num);
            m = 16'd1;
            x = 16'd1;
            b = 16'd1;
            #1;

            check_outputs(32'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Typical Values (y = 10*5 + 100)", test_num);
            m = 16'd10;
            x = 16'd5;
            b = 16'd100;
            #1;

            check_outputs(32'd150);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Product (y = 1000*1000 + 0)", test_num);
            m = 16'd1000;
            x = 16'd1000;
            b = 16'd0;
            #1;

            check_outputs(32'd1000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 16-bit inputs (y = Max*Max + Max)", test_num);

            m = 16'hFFFF;
            x = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Multiplier (y = 2^8 * 2^8 + 1)", test_num);
            m = 16'h0100;
            x = 16'h0100;
            b = 16'h0001;
            #1;

            check_outputs(32'h00010001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Slope (y = 32768*2 + 0)", test_num);
            m = 16'd32768;
            x = 16'd2;
            b = 16'd0;
            #1;

            check_outputs(32'd65536);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Numbers (y = 17*13 + 7)", test_num);
            m = 16'd17;
            x = 16'd13;
            b = 16'd7;
            #1;

            check_outputs(32'd228);
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
