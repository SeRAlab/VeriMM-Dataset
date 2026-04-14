`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg TE;
    wire Z;

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
        .TE(TE),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; D = 0; TE = 1;
        #10;
        $display("Testcase %03d: All inputs LOW, TE=1 (Normal Operation)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 1; B = 0; C = 0; D = 0; TE = 1;
        #10;
        $display("Testcase %03d: Input A HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 0; B = 1; C = 0; D = 0; TE = 1;
        #10;
        $display("Testcase %03d: Input B HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 1; D = 0; TE = 1;
        #10;
        $display("Testcase %03d: Input C HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; D = 1; TE = 1;
        #10;
        $display("Testcase %03d: Input D HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 1; B = 1; C = 0; D = 0; TE = 1;
        #10;
        $display("Testcase %03d: Multiple inputs (A,B) HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 1; B = 1; C = 1; D = 1; TE = 1;
        #10;
        $display("Testcase %03d: All inputs HIGH, TE=1", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; D = 0; TE = 0;
        #10;
        $display("Testcase %03d: All inputs LOW, TE=0 (Disabled/Test Mode)", test_num);


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 1; B = 0; C = 1; D = 0; TE = 0;
        #10;
        $display("Testcase %03d: Mixed inputs, TE=0 (Disabled/Test Mode)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 0; B = 0; C = 0; D = 0; TE = 1;
        #5;
        TE = 0;
        #5;
        $display("Testcase %03d: Transition TE from 1 to 0 with all inputs LOW", test_num);
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
        input expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%b",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%b",
                         expected_Z);
                $display("  Got:      Z=%b",
                         Z);
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
