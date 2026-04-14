`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dtcin;
    reg i;
    reg oein;
    wire dtc;
    wire dtcbar;
    wire o;
    wire obar;
    wire oebout;
    wire oeout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dtcin(dtcin),
        .i(i),
        .oein(oein),
        .dtc(dtc),
        .dtcbar(dtcbar),
        .o(o),
        .obar(obar),
        .oebout(oebout),
        .oeout(oeout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Enabled, Input Low, DTC Low", test_num);
            i = 1'b0;
            oein = 1'b1;
            dtcin = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Enabled, Input High, DTC Low", test_num);
            i = 1'b1;
            oein = 1'b1;
            dtcin = 1'b0;
            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Enabled, Input High, DTC High", test_num);
            i = 1'b1;
            oein = 1'b1;
            dtcin = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Enabled, Input Low, DTC High", test_num);
            i = 1'b0;
            oein = 1'b1;
            dtcin = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Disabled State, DTC Low", test_num);
            i = 1'b1;
            oein = 1'b0;
            dtcin = 1'b0;
            #10;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Disabled State, DTC High", test_num);
            i = 1'b0;
            oein = 1'b0;
            dtcin = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
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
        input expected_dtc;
        input expected_dtcbar;
        input expected_o;
        input expected_obar;
        input expected_oebout;
        input expected_oeout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dtc === (expected_dtc ^ dtc ^ expected_dtc) &&
                expected_dtcbar === (expected_dtcbar ^ dtcbar ^ expected_dtcbar) &&
                expected_o === (expected_o ^ o ^ expected_o) &&
                expected_obar === (expected_obar ^ obar ^ expected_obar) &&
                expected_oebout === (expected_oebout ^ oebout ^ expected_oebout) &&
                expected_oeout === (expected_oeout ^ oeout ^ expected_oeout)) begin
                $display("PASS");
                $display("  Outputs: dtc=%b, dtcbar=%b, o=%b, obar=%b, oebout=%b, oeout=%b",
                         dtc, dtcbar, o, obar, oebout, oeout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dtc=%b, dtcbar=%b, o=%b, obar=%b, oebout=%b, oeout=%b",
                         expected_dtc, expected_dtcbar, expected_o, expected_obar, expected_oebout, expected_oeout);
                $display("  Got:      dtc=%b, dtcbar=%b, o=%b, obar=%b, oebout=%b, oeout=%b",
                         dtc, dtcbar, o, obar, oebout, oeout);
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
