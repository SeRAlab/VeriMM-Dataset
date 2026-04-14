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
        $display("Testcase %0d: All inputs zero", test_num);
        intercept = 16'd0;
        slope = 16'd0;
        x = 16'd0;
        #1;

        check_outputs(32'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Standard positive integers", test_num);
        intercept = 16'd100;
        slope = 16'd5;
        x = 16'd20;

        #1;


        check_outputs(32'd200);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero slope (output equals intercept)", test_num);
        intercept = 16'hABCD;
        slope = 16'd0;
        x = 16'h1234;

        #1;


        check_outputs(32'h0000ABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero intercept (output equals mx)", test_num);
        intercept = 16'd0;
        slope = 16'd10;
        x = 16'd150;

        #1;


        check_outputs(32'd1500);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Larger product exceeding 16 bits", test_num);
        intercept = 16'd50;
        slope = 16'd1000;
        x = 16'd200;

        #1;


        check_outputs(32'd200050);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum bit-width boundaries", test_num);
        intercept = 16'hFFFF;
        slope = 16'hFFFF;
        x = 16'hFFFF;



        #1;




        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input x is zero", test_num);
        intercept = 16'd250;
        slope = 16'd99;
        x = 16'd0;

        #1;


        check_outputs(32'd250);
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
