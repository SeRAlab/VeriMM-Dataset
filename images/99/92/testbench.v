`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] B;
    reg [7:0] G;
    reg [7:0] R;
    reg [7:0] delta;
    reg [1:0] locationMax;
    reg [7:0] max;
    wire [8:0] H;
    wire [13:0] temp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B(B),
        .G(G),
        .R(R),
        .delta(delta),
        .locationMax(locationMax),
        .max(max),
        .H(H),
        .temp(temp)
    );
    task testcase001;

    begin
        test_num = 1;
        R = 100; G = 100; B = 100; delta = 0; max = 100; locationMax = 0;
        #1;

        check_outputs(9'd0, 14'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        R = 200; G = 100; B = 50; delta = 150; max = 200; locationMax = 2'd0;


        #1;



        check_outputs(9'd20, 14'h0BB8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        R = 200; G = 50; B = 100; delta = 150; max = 200; locationMax = 2'd0;


        #1;



        check_outputs(9'd340, 14'h3448);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        R = 50; G = 200; B = 100; delta = 150; max = 200; locationMax = 2'd1;


        #1;



        check_outputs(9'd140, 14'h0BB8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        R = 100; G = 200; B = 50; delta = 150; max = 200; locationMax = 2'd1;


        #1;



        check_outputs(9'd100, 14'h3448);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        R = 100; G = 50; B = 200; delta = 150; max = 200; locationMax = 2'd2;


        #1;



        check_outputs(9'd260, 14'h0BB8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        R = 50; G = 100; B = 200; delta = 150; max = 200; locationMax = 2'd2;


        #1;



        check_outputs(9'd220, 14'h3448);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        R = 255; G = 0; B = 0; delta = 255; max = 255; locationMax = 2'd0;


        #1;



        check_outputs(9'd0, 14'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        R = 0; G = 255; B = 0; delta = 255; max = 255; locationMax = 2'd1;


        #1;



        check_outputs(9'd120, 14'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        R = 0; G = 0; B = 255; delta = 255; max = 255; locationMax = 2'd2;


        #1;



        check_outputs(9'd240, 14'h0);
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
        input [8:0] expected_H;
        input [13:0] expected_temp;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_H === (expected_H ^ H ^ expected_H) &&
                expected_temp === (expected_temp ^ temp ^ expected_temp)) begin
                $display("PASS");
                $display("  Outputs: H=%h, temp=%h",
                         H, temp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: H=%h, temp=%h",
                         expected_H, expected_temp);
                $display("  Got:      H=%h, temp=%h",
                         H, temp);
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
