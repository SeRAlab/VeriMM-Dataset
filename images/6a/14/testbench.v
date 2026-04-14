`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg iCLK;
    reg iRST;
    reg iSIG;
    wire oFE;
    wire oRE;
    wire oRFE;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iCLK(iCLK),
        .iRST(iRST),
        .iSIG(iSIG),
        .oFE(oFE),
        .oRE(oRE),
        .oRFE(oRFE)
    );

    // Clock generation (10ns period)
    initial begin
        iCLK = 0;
        forever #5 iCLK = ~iCLK;
    end

        task reset_dut;

        begin
            iRST = 1;
            iSIG = 0;
            @(posedge iCLK);
            #1 iRST = 0;
            @(posedge iCLK);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Rising Edge Detection", test_num);

            iSIG = 1;
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Falling Edge Detection", test_num);

            iSIG = 1;
            @(posedge iCLK);
            iSIG = 0;
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Steady State Low", test_num);

            iSIG = 0;
            @(posedge iCLK);
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Steady State High", test_num);

            iSIG = 1;
            @(posedge iCLK);
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Output during Reset", test_num);

            iSIG = 1;
            iRST = 1;
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Back-to-back (1->0->1 transition)", test_num);

            iSIG = 1;
            @(posedge iCLK);
            iSIG = 0;
            @(posedge iCLK);
            iSIG = 1;
            @(posedge iCLK);
            #1;


            #1;



            check_outputs(0, 1, 1);
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
        input expected_oFE;
        input expected_oRE;
        input expected_oRFE;
        begin
            if (expected_oFE === (expected_oFE ^ oFE ^ expected_oFE) &&
                expected_oRE === (expected_oRE ^ oRE ^ expected_oRE) &&
                expected_oRFE === (expected_oRFE ^ oRFE ^ expected_oRFE)) begin
                $display("PASS");
                $display("  Outputs: oFE=%b, oRE=%b, oRFE=%b",
                         oFE, oRE, oRFE);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oFE=%b, oRE=%b, oRFE=%b",
                         expected_oFE, expected_oRE, expected_oRFE);
                $display("  Got:      oFE=%b, oRE=%b, oRFE=%b",
                         oFE, oRE, oRFE);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,iCLK, iRST, iSIG, oFE, oRE, oRFE);
    end

endmodule
