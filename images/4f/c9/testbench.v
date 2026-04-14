`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] iDIG;
    wire [6:0] oSEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iDIG(iDIG),
        .oSEG(oSEG)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h00 (Digit 0)", test_num);
            iDIG = 5'h00;

            #1;


            check_outputs(7'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h01 (Digit 1)", test_num);
            iDIG = 5'h01;

            #1;


            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h02 (Digit 2)", test_num);
            iDIG = 5'h02;

            #1;


            check_outputs(7'h5B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h03 (Digit 3)", test_num);
            iDIG = 5'h03;

            #1;


            check_outputs(7'h4F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h04 (Digit 4)", test_num);
            iDIG = 5'h04;

            #1;


            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h05 (Digit 5)", test_num);
            iDIG = 5'h05;

            #1;


            check_outputs(7'h6D);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h06 (Digit 6)", test_num);
            iDIG = 5'h06;

            #1;


            check_outputs(7'h7D);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h07 (Digit 7)", test_num);
            iDIG = 5'h07;

            #1;


            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h08 (Digit 8)", test_num);
            iDIG = 5'h08;

            #1;


            check_outputs(7'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h09 (Digit 9)", test_num);
            iDIG = 5'h09;

            #1;


            check_outputs(7'h6F);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h0A (Char A)", test_num);
            iDIG = 5'h0A;

            #1;


            check_outputs(7'h77);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h0F (Char F)", test_num);
            iDIG = 5'h0F;

            #1;


            check_outputs(7'h71);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: iDIG = 5'h1F (Default/Max)", test_num);
            iDIG = 5'h1F;



            #1;




            check_outputs(7'h00);
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
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [6:0] expected_oSEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSEG === (expected_oSEG ^ oSEG ^ expected_oSEG)) begin
                $display("PASS");
                $display("  Outputs: oSEG=%h",
                         oSEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSEG=%h",
                         expected_oSEG);
                $display("  Got:      oSEG=%h",
                         oSEG);
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
