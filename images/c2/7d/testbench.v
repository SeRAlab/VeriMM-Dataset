`timescale 1ns/1ps

module six_input_module_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg B1;
    reg B2;
    reg C1;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    six_input_module dut (
        .A1(A1),
        .A2(A2),
        .B1(B1),
        .B2(B2),
        .C1(C1),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Y(Y)
    );
    task initialize_circuit;

        begin
            A1 = 0; A2 = 0; B1 = 0; B2 = 0; C1 = 0;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=1, B1=0, B2=0, C1=0 (Rule 1)", test_num);
            initialize_circuit();
            A1 = 1; A2 = 1; B1 = 0; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=0, A2=0, B1=1, B2=1, C1=0 (Rule 2)", test_num);
            initialize_circuit();
            A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C1=1, others 0 (Rule 3)", test_num);
            initialize_circuit();
            C1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1=1, A2=0, B1=1, B2=0, C1=0 (Default)", test_num);
            initialize_circuit();
            A1 = 1; A2 = 0; B1 = 1; B2 = 0; C1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Zero (Default)", test_num);
            initialize_circuit();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C1=1 overriding Rule 2 inputs", test_num);
            initialize_circuit();
            A1 = 0; A2 = 0; B1 = 1; B2 = 1; C1 = 1;
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
        $display("six_input_module Testbench");
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
