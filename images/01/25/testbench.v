`timescale 1ns/1ps

module LinearRegression_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] x3;
    reg [7:0] x4;
    wire [15:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LinearRegression dut (
        .x1(x1),
        .x2(x2),
        .x3(x3),
        .x4(x4),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            x1 = 8'd0;
            x2 = 8'd0;
            x3 = 8'd0;
            x4 = 8'd0;

            #1;


            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unit inputs", test_num);
            x1 = 8'd1;
            x2 = 8'd1;
            x3 = 8'd1;
            x4 = 8'd1;

            #1;


            check_outputs(16'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single active input (x3)", test_num);
            x1 = 8'd0;
            x2 = 8'd0;
            x3 = 8'd10;
            x4 = 8'd0;

            #1;


            check_outputs(16'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum input values", test_num);
            x1 = 8'd255;
            x2 = 8'd255;
            x3 = 8'd255;
            x4 = 8'd255;

            #1;


            check_outputs(16'd2550);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed arbitrary values", test_num);
            x1 = 8'd5;
            x2 = 8'd10;
            x3 = 8'd15;
            x4 = 8'd20;

            #1;


            check_outputs(16'd150);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating large and small values", test_num);
            x1 = 8'd100;
            x2 = 8'd1;
            x3 = 8'd50;
            x4 = 8'd2;

            #1;


            check_outputs(16'd260);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LinearRegression Testbench");
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
