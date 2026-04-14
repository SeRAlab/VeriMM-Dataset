`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] Bin;
    wire [3:0] huns;
    wire [3:0] ones;
    wire [3:0] tens;
    wire [3:0] thous;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Bin(Bin),
        .huns(huns),
        .ones(ones),
        .tens(tens),
        .thous(thous)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 0 (Minimum Value)", test_num);
            Bin = 12'd0;

            #1;


            check_outputs(4'd0, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 4095 (Maximum Value)", test_num);
            Bin = 12'd4095;

            #1;


            check_outputs(4'd0, 4'd5, 4'd9, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 1234", test_num);
            Bin = 12'd1234;

            #1;


            check_outputs(4'd2, 4'd4, 4'd3, 4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 7", test_num);
            Bin = 12'd7;

            #1;


            check_outputs(4'd0, 4'd7, 4'd0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 15 (Add-3 logic check for ones)", test_num);
            Bin = 12'd15;

            #1;


            check_outputs(4'd0, 4'd5, 4'd1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 99", test_num);
            Bin = 12'd99;

            #1;


            check_outputs(4'd0, 4'd9, 4'd9, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 100", test_num);
            Bin = 12'd100;

            #1;


            check_outputs(4'd1, 4'd0, 4'd0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 512 (2^9)", test_num);
            Bin = 12'd512;

            #1;


            check_outputs(4'd5, 4'd2, 4'd1, 4'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 2048 (2^11)", test_num);
            Bin = 12'd2048;

            #1;


            check_outputs(4'd0, 4'd8, 4'd4, 4'd2);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input = 3999", test_num);
            Bin = 12'd3999;

            #1;


            check_outputs(4'd9, 4'd9, 4'd9, 4'd3);
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
        input [3:0] expected_huns;
        input [3:0] expected_ones;
        input [3:0] expected_tens;
        input [3:0] expected_thous;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_huns === (expected_huns ^ huns ^ expected_huns) &&
                expected_ones === (expected_ones ^ ones ^ expected_ones) &&
                expected_tens === (expected_tens ^ tens ^ expected_tens) &&
                expected_thous === (expected_thous ^ thous ^ expected_thous)) begin
                $display("PASS");
                $display("  Outputs: huns=%h, ones=%h, tens=%h, thous=%h",
                         huns, ones, tens, thous);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: huns=%h, ones=%h, tens=%h, thous=%h",
                         expected_huns, expected_ones, expected_tens, expected_thous);
                $display("  Got:      huns=%h, ones=%h, tens=%h, thous=%h",
                         huns, ones, tens, thous);
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
