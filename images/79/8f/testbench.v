`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg SEL0;
    reg SEL1;
    wire Y;

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
        .SEL0(SEL0),
        .SEL1(SEL1),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=00 (D), D=0, Others=1", test_num);
        SEL1 = 0; SEL0 = 0;
        A = 1; B = 1; C = 1; D = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=00 (D), D=1, Others=0", test_num);
        SEL1 = 0; SEL0 = 0;
        A = 0; B = 0; C = 0; D = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=01 (C), C=0, Others=1", test_num);
        SEL1 = 0; SEL0 = 1;
        A = 1; B = 1; C = 0; D = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=01 (C), C=1, Others=0", test_num);
        SEL1 = 0; SEL0 = 1;
        A = 0; B = 0; C = 1; D = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=10 (B), B=0, Others=1", test_num);
        SEL1 = 1; SEL0 = 0;
        A = 1; B = 0; C = 1; D = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=10 (B), B=1, Others=0", test_num);
        SEL1 = 1; SEL0 = 0;
        A = 0; B = 1; C = 0; D = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=11 (A), A=0, Others=1", test_num);
        SEL1 = 1; SEL0 = 1;
        A = 0; B = 1; C = 1; D = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: SEL=11 (A), A=1, Others=0", test_num);
        SEL1 = 1; SEL0 = 1;
        A = 1; B = 0; C = 0; D = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs 1, sweep SEL", test_num);
        A=1; B=1; C=1; D=1;

        SEL1=0; SEL0=0; #1; if (Y !== 1) fail_count++; else pass_count++;
        SEL1=0; SEL0=1; #1; if (Y !== 1) fail_count++; else pass_count++;
        SEL1=1; SEL0=0; #1; if (Y !== 1) fail_count++; else pass_count++;
        SEL1=1; SEL0=1; #1; if (Y !== 1) fail_count++; else pass_count++;

        $display("  Sweep check completed for Case 009");
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs 0, sweep SEL", test_num);
        A=0; B=0; C=0; D=0;

        SEL1=0; SEL0=0; #1; if (Y !== 0) fail_count++; else pass_count++;
        SEL1=0; SEL0=1; #1; if (Y !== 0) fail_count++; else pass_count++;
        SEL1=1; SEL0=0; #1; if (Y !== 0) fail_count++; else pass_count++;
        SEL1=1; SEL0=1; #1; if (Y !== 0) fail_count++; else pass_count++;

        $display("  Sweep check completed for Case 010");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
