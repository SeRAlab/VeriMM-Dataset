`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    wire CA;
    wire CB;
    wire CC;
    wire CD;
    wire CE;
    wire CF;
    wire CG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .CA(CA),
        .CB(CB),
        .CC(CC),
        .CD(CD),
        .CE(CE),
        .CF(CF),
        .CG(CG)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd0;
            #10;
            $display("Test Case %0d: Input A = 0", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd1;
            #10;
            $display("Test Case %0d: Input A = 1", test_num);

            #1;


            check_outputs(0, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd2;
            #10;
            $display("Test Case %0d: Input A = 2", test_num);

            #1;


            check_outputs(1, 1, 0, 1, 1, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd3;
            #10;
            $display("Test Case %0d: Input A = 3", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd4;
            #10;
            $display("Test Case %0d: Input A = 4", test_num);

            #1;


            check_outputs(0, 1, 1, 0, 0, 1, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd5;
            #10;
            $display("Test Case %0d: Input A = 5", test_num);

            #1;


            check_outputs(1, 0, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'd6;
            #10;
            $display("Test Case %0d: Input A = 6", test_num);

            #1;


            check_outputs(1, 0, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'd7;
            #10;
            $display("Test Case %0d: Input A = 7", test_num);

            #1;


            check_outputs(1, 1, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'd8;
            #10;
            $display("Test Case %0d: Input A = 8", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 1, 1, 1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd9;
            #10;
            $display("Test Case %0d: Input A = 9", test_num);

            #1;


            check_outputs(1, 1, 1, 1, 0, 1, 1);
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
        input expected_CA;
        input expected_CB;
        input expected_CC;
        input expected_CD;
        input expected_CE;
        input expected_CF;
        input expected_CG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CA === (expected_CA ^ CA ^ expected_CA) &&
                expected_CB === (expected_CB ^ CB ^ expected_CB) &&
                expected_CC === (expected_CC ^ CC ^ expected_CC) &&
                expected_CD === (expected_CD ^ CD ^ expected_CD) &&
                expected_CE === (expected_CE ^ CE ^ expected_CE) &&
                expected_CF === (expected_CF ^ CF ^ expected_CF) &&
                expected_CG === (expected_CG ^ CG ^ expected_CG)) begin
                $display("PASS");
                $display("  Outputs: CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b",
                         CA, CB, CC, CD, CE, CF, CG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b",
                         expected_CA, expected_CB, expected_CC, expected_CD, expected_CE, expected_CF, expected_CG);
                $display("  Got:      CA=%b, CB=%b, CC=%b, CD=%b, CE=%b, CF=%b, CG=%b",
                         CA, CB, CC, CD, CE, CF, CG);
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
