`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [1:0] b;
    reg [1:0] c;
    wire [5:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 4'sd5; b = 2'sd0; c = 2'd0;
        #1;

        check_outputs(6'sd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = -4'sd5; b = 2'sd0; c = 2'd0;
        #1;

        check_outputs(-6'sd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 4'sd3; b = 2'sd1; c = 2'd0;
        #1;

        check_outputs(6'sd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = -4'sd3; b = 2'sd1; c = 2'd0;
        #1;

        check_outputs(-6'sd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 4'sd6; b = -2'sd1; c = 2'd0;
        #1;

        check_outputs(6'sd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = -4'sd6; b = -2'sd1; c = 2'd0;
        #1;

        check_outputs(-6'sd3);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 4'sd0; b = 2'sd1; c = 2'd2;
        #1;

        check_outputs(6'sd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = -4'sd8; b = -2'sd2; c = 2'd0;
        #1;

        check_outputs(-6'sd2);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 4'sd2; b = 2'sd0; c = 2'd2;
        #1;

        check_outputs(6'sd8);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = -4'sd2; b = 2'sd1; c = 2'd1;
        #1;

        check_outputs(-6'sd8);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        a = -4'sd8; b = 2'sd0; c = 2'd2;
        #1;

        check_outputs(-6'sd32);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        a = 4'sd1; b = 2'sd1; c = 2'd3;
        #1;

        check_outputs(6'sd16);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        a = -4'sd4; b = -2'sd1; c = 2'd3;
        #1;

        check_outputs(-6'sd16);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        a = 4'sd7; b = 2'sd1; c = 2'd1;
        #1;

        check_outputs(6'sd28);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        a = -4'sd7; b = -2'sd2; c = 2'd2;
        #1;

        check_outputs(-6'sd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [5:0] expected_y;
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
