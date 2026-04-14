`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] sw;
    wire [7:0] an;
    wire ca;
    wire cb;
    wire cc;
    wire cd;
    wire ce;
    wire cf;
    wire cg;
    wire dp;
    wire [15:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sw(sw),
        .an(an),
        .ca(ca),
        .cb(cb),
        .cc(cc),
        .cd(cd),
        .ce(ce),
        .cf(cf),
        .cg(cg),
        .dp(dp),
        .led(led)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All Switches OFF", test_num);
            sw = 16'h0000;

            #1;


            check_outputs(8'hFF, 1, 1, 1, 1, 1, 1, 1, 1, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All Switches ON", test_num);
            sw = 16'hFFFF;

            #1;


            check_outputs(8'h00, 0, 0, 0, 0, 0, 0, 0, 0, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating Bits AAAA", test_num);
            sw = 16'hAAAA;


            #1;



            check_outputs(8'h55, 1, 0, 1, 0, 1, 0, 1, 0, 16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating Bits 5555", test_num);
            sw = 16'h5555;


            #1;



            check_outputs(8'hAA, 0, 1, 0, 1, 0, 1, 0, 1, 16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Upper byte ON, Lower byte OFF", test_num);
            sw = 16'hFF00;


            #1;



            check_outputs(8'h00, 1, 1, 1, 1, 1, 1, 1, 1, 16'hFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Upper byte OFF, Lower byte ON", test_num);
            sw = 16'h00FF;


            #1;



            check_outputs(8'hFF, 0, 0, 0, 0, 0, 0, 0, 0, 16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Mixed pattern 1234", test_num);
            sw = 16'h1234;


            #1;



            check_outputs(8'hED, 1, 1, 0, 1, 0, 0, 1, 1, 16'h1234);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Mixed pattern ABCD", test_num);
            sw = 16'hABCD;


            #1;



            check_outputs(8'h54, 0, 1, 0, 0, 1, 1, 0, 0, 16'hABCD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTestcase %0d: Boundary Bits (8001)", test_num);
            sw = 16'h8001;


            #1;



            check_outputs(8'h7F, 0, 1, 1, 1, 1, 1, 1, 1, 16'h8001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTestcase %0d: Boundary Bits (0180)", test_num);
            sw = 16'h0180;


            #1;



            check_outputs(8'hFE, 1, 1, 1, 1, 1, 1, 1, 0, 16'h0180);
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
        input [7:0] expected_an;
        input expected_ca;
        input expected_cb;
        input expected_cc;
        input expected_cd;
        input expected_ce;
        input expected_cf;
        input expected_cg;
        input expected_dp;
        input [15:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_an === (expected_an ^ an ^ expected_an) &&
                expected_ca === (expected_ca ^ ca ^ expected_ca) &&
                expected_cb === (expected_cb ^ cb ^ expected_cb) &&
                expected_cc === (expected_cc ^ cc ^ expected_cc) &&
                expected_cd === (expected_cd ^ cd ^ expected_cd) &&
                expected_ce === (expected_ce ^ ce ^ expected_ce) &&
                expected_cf === (expected_cf ^ cf ^ expected_cf) &&
                expected_cg === (expected_cg ^ cg ^ expected_cg) &&
                expected_dp === (expected_dp ^ dp ^ expected_dp) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: an=%h, ca=%b, cb=%b, cc=%b, cd=%b, ce=%b, cf=%b, cg=%b, dp=%b, led=%h",
                         an, ca, cb, cc, cd, ce, cf, cg, dp, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: an=%h, ca=%b, cb=%b, cc=%b, cd=%b, ce=%b, cf=%b, cg=%b, dp=%b, led=%h",
                         expected_an, expected_ca, expected_cb, expected_cc, expected_cd, expected_ce, expected_cf, expected_cg, expected_dp, expected_led);
                $display("  Got:      an=%h, ca=%b, cb=%b, cc=%b, cd=%b, ce=%b, cf=%b, cg=%b, dp=%b, led=%h",
                         an, ca, cb, cc, cd, ce, cf, cg, dp, led);
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
