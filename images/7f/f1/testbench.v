`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EN;
    reg IN0;
    reg IN1;
    reg IN2;
    reg IN3;
    wire [15:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .IN0(IN0),
        .IN1(IN1),
        .IN2(IN2),
        .IN3(IN3),
        .OUT(OUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=0, Inputs=1111 - Expected OUT=0000", test_num);
            EN = 0;
            IN3 = 1; IN2 = 1; IN1 = 1; IN0 = 1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=0000 - Expected OUT=0001", test_num);
            EN = 1;
            IN3 = 0; IN2 = 0; IN1 = 0; IN0 = 0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=0001 - Expected OUT=0002", test_num);
            EN = 1;
            IN3 = 0; IN2 = 0; IN1 = 0; IN0 = 1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=0011 - Expected OUT=0008", test_num);
            EN = 1;
            IN3 = 0; IN2 = 0; IN1 = 1; IN0 = 1;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=0101 - Expected OUT=0020", test_num);
            EN = 1;
            IN3 = 0; IN2 = 1; IN1 = 0; IN0 = 1;
            #1;

            check_outputs(16'h0020);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=1000 - Expected OUT=0100", test_num);
            EN = 1;
            IN3 = 1; IN2 = 0; IN1 = 0; IN0 = 0;
            #1;

            check_outputs(16'h0100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=1010 - Expected OUT=0400", test_num);
            EN = 1;
            IN3 = 1; IN2 = 0; IN1 = 1; IN0 = 0;
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=1100 - Expected OUT=1000", test_num);
            EN = 1;
            IN3 = 1; IN2 = 1; IN1 = 0; IN0 = 0;
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=1, Inputs=1111 - Expected OUT=8000", test_num);
            EN = 1;
            IN3 = 1; IN2 = 1; IN1 = 1; IN0 = 1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Enable=0 transition - Expected OUT=0000", test_num);
            EN = 0;
            IN3 = 0; IN2 = 1; IN1 = 1; IN0 = 0;
            #1;

            check_outputs(16'h0000);
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
        input [15:0] expected_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
