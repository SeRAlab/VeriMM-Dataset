`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] c1;
    reg [6:0] c2;
    reg [12:0] in1;
    reg [12:0] in2;
    wire [20:0] Out_add;
    wire [20:0] Out_sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c1(c1),
        .c2(c2),
        .in1(in1),
        .in2(in2),
        .Out_add(Out_add),
        .Out_sub(Out_sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            in1 = 13'd0;
            in2 = 13'd0;
            c1  = 7'd0;
            c2  = 7'd0;


            #1;



            check_outputs(21'd0, 21'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Unit coefficients", test_num);
            in1 = 13'd100;
            in2 = 13'd50;
            c1  = 7'd1;
            c2  = 7'd1;


            #1;



            check_outputs(21'd150, 21'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Subtraction equals zero", test_num);
            in1 = 13'd10;
            in2 = 13'd20;
            c1  = 7'd2;
            c2  = 7'd4;


            #1;



            check_outputs(21'd100, 21'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Negative Subtraction Result", test_num);
            in1 = 13'd10;
            in2 = 13'd100;
            c1  = 7'd10;
            c2  = 7'd1;



            #1;




            check_outputs(21'd200, 21'h1FFC22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Input Values", test_num);
            in1 = 13'h1FFF;
            in2 = 13'h1FFF;
            c1  = 7'h7F;
            c2  = 7'h7F;


            #1;



            check_outputs(21'd2080514, 21'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Asymmetric values", test_num);
            in1 = 13'd500;
            in2 = 13'd250;
            c1  = 7'd10;
            c2  = 7'd20;


            #1;



            check_outputs(21'd10000, 21'd7500);
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
        input [20:0] expected_Out_add;
        input [20:0] expected_Out_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out_add === (expected_Out_add ^ Out_add ^ expected_Out_add) &&
                expected_Out_sub === (expected_Out_sub ^ Out_sub ^ expected_Out_sub)) begin
                $display("PASS");
                $display("  Outputs: Out_add=%h, Out_sub=%h",
                         Out_add, Out_sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out_add=%h, Out_sub=%h",
                         expected_Out_add, expected_Out_sub);
                $display("  Got:      Out_add=%h, Out_sub=%h",
                         Out_add, Out_sub);
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
