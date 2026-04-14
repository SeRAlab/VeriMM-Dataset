`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x1;
    reg [3:0] x2;
    wire [4:0] y;

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
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum inputs (x1=0, x2=0)", test_num);
        x1 = 4'd0;
        x2 = 4'd0;

        #1;


        check_outputs(5'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small values (x1=1, x2=1)", test_num);
        x1 = 4'd1;
        x2 = 4'd1;

        #1;


        check_outputs(5'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x1 dominant (x1=5, x2=1)", test_num);
        x1 = 4'd5;
        x2 = 4'd1;

        #1;


        check_outputs(5'd18);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: x2 dominant (x1=2, x2=10)", test_num);
        x1 = 4'd2;
        x2 = 4'd10;

        #1;


        check_outputs(5'd27);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - Max output for 5-bit (x1=10, x2=0)", test_num);
        x1 = 4'd10;
        x2 = 4'd0;

        #1;


        check_outputs(5'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - Max x2 contribution (x1=0, x2=15)", test_num);
        x1 = 4'd0;
        x2 = 4'd15;

        #1;


        check_outputs(5'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range values (x1=4, x2=3)", test_num);
        x1 = 4'd4;
        x2 = 4'd3;

        #1;


        check_outputs(5'd19);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Truncation check (x1=10, x2=1)", test_num);
        x1 = 4'd10;
        x2 = 4'd1;

        #1;


        check_outputs(5'd1);
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
