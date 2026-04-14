`timescale 1ns/1ps

module linear_regression_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] b;
    reg [15:0] w1;
    reg [15:0] w2;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    linear_regression dut (
        .b(b),
        .w1(w1),
        .w2(w2),
        .x1(x1),
        .x2(x2),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs zero", test_num);
            w1 = 16'd0; x1 = 16'd0;
            w2 = 16'd0; x2 = 16'd0;
            b  = 16'd0;
            #1;

            check_outputs(32'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unit weights, no bias", test_num);
            w1 = 16'd1; x1 = 16'd15;
            w2 = 16'd1; x2 = 16'd25;
            b  = 16'd0;

            #1;


            check_outputs(32'd40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bias only (zero weights)", test_num);
            w1 = 16'd0; x1 = 16'd500;
            w2 = 16'd0; x2 = 16'd300;
            b  = 16'd1024;

            #1;


            check_outputs(32'd1024);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed weights and values", test_num);
            w1 = 16'd10; x1 = 16'd5;
            w2 = 16'd20; x2 = 16'd4;
            b  = 16'd100;

            #1;


            check_outputs(32'd230);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Larger values (intermediate 32-bit products)", test_num);
            w1 = 16'd1000; x1 = 16'd1000;
            w2 = 16'd500;  x2 = 16'd2000;
            b  = 16'd5000;


            #1;



            check_outputs(32'd2005000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum 16-bit weight check", test_num);
            w1 = 16'hFFFF; x1 = 16'd1;
            w2 = 16'd0;    x2 = 16'd0;
            b  = 16'd1;

            #1;


            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High utilization of 32-bit range", test_num);
            w1 = 16'd30000; x1 = 16'd60000;
            w2 = 16'd20000; x2 = 16'd50000;
            b  = 16'hFFFF;


            #1;



            check_outputs(32'hA6E67FFF);
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
