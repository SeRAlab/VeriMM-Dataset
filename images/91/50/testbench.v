`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg EN;
    wire [7:0] COUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .EN(EN),
        .COUT(COUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, ABC=000", test_num);
            EN = 0; A = 0; B = 0; C = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, ABC=111", test_num);
            EN = 0; A = 1; B = 1; C = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=000", test_num);
            EN = 1; A = 0; B = 0; C = 0;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=001", test_num);
            EN = 1; A = 0; B = 0; C = 1;
            #1;

            check_outputs(8'hFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=010", test_num);
            EN = 1; A = 0; B = 1; C = 0;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=011", test_num);
            EN = 1; A = 0; B = 1; C = 1;
            #1;

            check_outputs(8'hF7);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=100", test_num);
            EN = 1; A = 1; B = 0; C = 0;
            #1;

            check_outputs(8'hEF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=101", test_num);
            EN = 1; A = 1; B = 0; C = 1;
            #1;

            check_outputs(8'hDF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=110", test_num);
            EN = 1; A = 1; B = 1; C = 0;
            #1;

            check_outputs(8'hBF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, ABC=111", test_num);
            EN = 1; A = 1; B = 1; C = 1;
            #1;

            check_outputs(8'h7F);
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
        input [7:0] expected_COUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT)) begin
                $display("PASS");
                $display("  Outputs: COUT=%h",
                         COUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%h",
                         expected_COUT);
                $display("  Got:      COUT=%h",
                         COUT);
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
