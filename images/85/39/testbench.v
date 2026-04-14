`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg M_IN_0;
    reg M_IN_1;
    reg M_SEL;
    wire M_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .M_IN_0(M_IN_0),
        .M_IN_1(M_IN_1),
        .M_SEL(M_SEL),
        .M_OUT(M_OUT)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: SEL=0, IN0=0, IN1=0", test_num);
            M_SEL = 0; M_IN_0 = 0; M_IN_1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: SEL=0, IN0=1, IN1=0", test_num);
            M_SEL = 0; M_IN_0 = 1; M_IN_1 = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: SEL=0, IN0=0, IN1=1", test_num);
            M_SEL = 0; M_IN_0 = 0; M_IN_1 = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: SEL=0, IN0=1, IN1=1", test_num);
            M_SEL = 0; M_IN_0 = 1; M_IN_1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: SEL=1, IN0=0, IN1=0", test_num);
            M_SEL = 1; M_IN_0 = 0; M_IN_1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: SEL=1, IN0=1, IN1=0", test_num);
            M_SEL = 1; M_IN_0 = 1; M_IN_1 = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: SEL=1, IN0=0, IN1=1", test_num);
            M_SEL = 1; M_IN_0 = 0; M_IN_1 = 1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: SEL=1, IN0=1, IN1=1", test_num);
            M_SEL = 1; M_IN_0 = 1; M_IN_1 = 1;
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
        input expected_M_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M_OUT === (expected_M_OUT ^ M_OUT ^ expected_M_OUT)) begin
                $display("PASS");
                $display("  Outputs: M_OUT=%b",
                         M_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M_OUT=%b",
                         expected_M_OUT);
                $display("  Got:      M_OUT=%b",
                         M_OUT);
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
