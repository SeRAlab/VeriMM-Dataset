`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] intercept;
    reg [15:0] slope;
    reg [15:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .intercept(intercept),
        .slope(slope),
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            intercept = 16'h0000;
            slope     = 16'h0000;
            x         = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple positive values (y = 5*10 + 2)", test_num);
            intercept = 16'h0002;
            slope     = 16'h0005;
            x         = 16'h000A;
            #1;

            check_outputs(32'h00000034);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero slope (y = 0*x + intercept)", test_num);
            intercept = 16'h03E8;
            slope     = 16'h0000;
            x         = 16'hFFFF;
            #1;

            check_outputs(32'h000003E8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero intercept (y = slope*x + 0)", test_num);
            intercept = 16'h0000;
            slope     = 16'h0010;
            x         = 16'h0040;
            #1;

            check_outputs(32'h00000400);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible values", test_num);
            intercept = 16'hFFFF;
            slope     = 16'hFFFF;
            x         = 16'hFFFF;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large slope and x, small intercept", test_num);
            intercept = 16'h0001;
            slope     = 16'h8000;
            x         = 16'h0002;
            #1;

            check_outputs(32'h00010001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Medium range calculation", test_num);
            intercept = 16'h1234;
            slope     = 16'h00AB;
            x         = 16'h04D2;

            #1;


            check_outputs(32'h00034A7A);
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
