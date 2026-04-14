`timescale 1ns/1ps

module hazard_detection_resolution_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    wire F;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detection_resolution dut (
        .A(A),
        .B(B),
        .C(C),
        .F(F)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Input ABC = 000 (m0)", test_num);
        A = 0; B = 0; C = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Input ABC = 001 (m1)", test_num);
        A = 0; B = 0; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Input ABC = 010 (m2)", test_num);
        A = 0; B = 1; C = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Input ABC = 011 (m3)", test_num);
        A = 0; B = 1; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Input ABC = 100 (m4)", test_num);
        A = 1; B = 0; C = 0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Input ABC = 101 (m5)", test_num);
        A = 1; B = 0; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Input ABC = 110 (m6)", test_num);
        A = 1; B = 1; C = 0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Input ABC = 111 (m7)", test_num);
        A = 1; B = 1; C = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Transition m3(011) -> m7(111)", test_num);
        A = 0; B = 1; C = 1;
        #5;
        A = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Transition m2(010) -> m6(110)", test_num);
        A = 0; B = 1; C = 0;
        #5;
        A = 1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hazard_detection_resolution Testbench");
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
        input expected_F;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_F === (expected_F ^ F ^ expected_F)) begin
                $display("PASS");
                $display("  Outputs: F=%b",
                         F);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: F=%b",
                         expected_F);
                $display("  Got:      F=%b",
                         F);
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
