`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg En;
    wire Q;
    wire Qc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .En(En),
        .Q(Q),
        .Qc(Qc)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transparent Mode (Set Low)", test_num);
        En = 1;
        D = 0;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Transparent Mode (Set High)", test_num);
        En = 1;
        D = 1;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Hold Mode (Hold High)", test_num);

        En = 1; D = 1;
        #10;

        En = 0;
        #5;

        D = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Hold Mode (Hold Low)", test_num);

        En = 1; D = 0;
        #10;

        En = 0;
        #5;

        D = 1;
        #10;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiple transitions while En=1", test_num);
        En = 1;
        D = 0; #5;
        D = 1; #5;
        D = 0; #5;
        D = 1; #10;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Capture value at falling edge of En", test_num);
        En = 1;
        D = 0;
        #10;
        D = 1;
        #2;
        En = 0;
        #5;
        D = 0;
        #10;
        #1;

        check_outputs(1'b1, 1'b0);
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
        input expected_Q;
        input expected_Qc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qc === (expected_Qc ^ Qc ^ expected_Qc)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qc=%b",
                         Q, Qc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qc=%b",
                         expected_Q, expected_Qc);
                $display("  Got:      Q=%b, Qc=%b",
                         Q, Qc);
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
