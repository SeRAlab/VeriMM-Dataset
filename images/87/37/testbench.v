`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [7:0] C;
    wire X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .X(X)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=3, B=4, C=5 (Smallest: 3,4 Largest: 5)", test_num);
        A = 8'd3; B = 8'd4; C = 8'd5;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=10, B=20, C=30 (Smallest: 10,20 Largest: 30)", test_num);
        A = 8'd10; B = 8'd20; C = 8'd30;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=2, B=2, C=10 (Smallest: 2,2 Largest: 10)", test_num);
        A = 8'd2; B = 8'd2; C = 8'd10;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=50, B=50, C=50 (Smallest: 50,50 Largest: 50)", test_num);
        A = 8'd50; B = 8'd50; C = 8'd50;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=100, B=60, C=70 (Smallest: 60,70 Largest: 100)", test_num);
        A = 8'd100; B = 8'd60; C = 8'd70;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=40, B=120, C=90 (Smallest: 40,90 Largest: 120)", test_num);
        A = 8'd40; B = 8'd120; C = 8'd90;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=0, B=5, C=5 (Smallest: 0,5 Largest: 5)", test_num);
        A = 8'd0; B = 8'd5; C = 8'd5;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=0, B=0, C=0 (Smallest: 0,0 Largest: 0)", test_num);
        A = 8'd0; B = 8'd0; C = 8'd0;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=255, B=255, C=255 (Smallest: 255,255 Largest: 255)", test_num);
        A = 8'd255; B = 8'd255; C = 8'd255;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: A=1, B=255, C=2 (Smallest: 1,2 Largest: 255)", test_num);
        A = 8'd1; B = 8'd255; C = 8'd2;

        #1;


        check_outputs(1'b0);
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
        input expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%b",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%b",
                         expected_X);
                $display("  Got:      X=%b",
                         X);
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
