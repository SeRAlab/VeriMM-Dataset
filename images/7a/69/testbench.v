`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg quarter;
    wire productA;
    wire productB;
    wire productC;
    wire productD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .quarter(quarter),
        .productA(productA),
        .productB(productB),
        .productC(productC),
        .productD(productD)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Product A and Insert Quarter", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        A = 1; #10; A = 0;
        #10;


        quarter = 1;


        #1;



        check_outputs(1, 0, 0, 0);


        quarter = 0;
        #10;
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Product B and Insert Quarter", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        B = 1; #10; B = 0;
        #10;


        quarter = 1;


        #1;



        check_outputs(0, 1, 0, 0);

        quarter = 0;
        #10;
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Product C and Insert Quarter", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        C = 1; #10; C = 0;
        #10;


        quarter = 1;


        #1;



        check_outputs(0, 0, 1, 0);

        quarter = 0;
        #10;
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Product D (Ignored) and Insert Quarter", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        D = 1; #10; D = 0;
        #10;


        quarter = 1;


        #1;



        check_outputs(0, 0, 0, 0);

        quarter = 0;
        #10;
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Insert Quarter without selection", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        quarter = 1;


        #1;



        check_outputs(0, 0, 0, 0);

        quarter = 0;
        #10;
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiple selection sequence (A then B)", test_num);

        A = 0; B = 0; C = 0; D = 0; quarter = 0;
        #10;


        A = 1; #10; A = 0; #10;


        B = 1; #10; B = 0; #10;


        quarter = 1;


        #1;



        check_outputs(0, 1, 0, 0);

        quarter = 0;
        #10;
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
        input expected_productA;
        input expected_productB;
        input expected_productC;
        input expected_productD;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_productA === (expected_productA ^ productA ^ expected_productA) &&
                expected_productB === (expected_productB ^ productB ^ expected_productB) &&
                expected_productC === (expected_productC ^ productC ^ expected_productC) &&
                expected_productD === (expected_productD ^ productD ^ expected_productD)) begin
                $display("PASS");
                $display("  Outputs: productA=%b, productB=%b, productC=%b, productD=%b",
                         productA, productB, productC, productD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: productA=%b, productB=%b, productC=%b, productD=%b",
                         expected_productA, expected_productB, expected_productC, expected_productD);
                $display("  Got:      productA=%b, productB=%b, productC=%b, productD=%b",
                         productA, productB, productC, productD);
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
