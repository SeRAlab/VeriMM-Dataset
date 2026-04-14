`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg INP;
    reg VDD;
    reg VSS;
    wire ZN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .INP(INP),
        .VDD(VDD),
        .VSS(VSS),
        .ZN(ZN)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation - Input Low (VDD=1, VSS=0, INP=0)", test_num);
            VDD = 1;
            VSS = 0;
            INP = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Normal Operation - Input High (VDD=1, VSS=0, INP=1)", test_num);
            VDD = 1;
            VSS = 0;
            INP = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Supply Management - Power Down (VDD=0, VSS=0, INP=0)", test_num);
            VDD = 0;
            VSS = 0;
            INP = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Supply Management - Power Down (VDD=0, VSS=0, INP=1)", test_num);
            VDD = 0;
            VSS = 0;
            INP = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Supply Management - Reversed Rails (VDD=0, VSS=1, INP=0)", test_num);
            VDD = 0;
            VSS = 1;
            INP = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Supply Management - Tied Rails (VDD=1, VSS=1, INP=1)", test_num);
            VDD = 1;
            VSS = 1;
            INP = 1;
            #10;
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
        input expected_ZN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ZN === (expected_ZN ^ ZN ^ expected_ZN)) begin
                $display("PASS");
                $display("  Outputs: ZN=%b",
                         ZN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ZN=%b",
                         expected_ZN);
                $display("  Got:      ZN=%b",
                         ZN);
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
