`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CLKFBIN;
    reg CLKIN1;
    reg PWRDWN;
    reg RST;
    wire CLKFBOUT;
    wire CLKOUT0;
    wire CLKOUT1;
    wire CLKOUT2;
    wire CLKOUT3;
    wire CLKOUT4;
    wire CLKOUT5;
    wire LOCKED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLKFBIN(CLKFBIN),
        .CLKIN1(CLKIN1),
        .PWRDWN(PWRDWN),
        .RST(RST),
        .CLKFBOUT(CLKFBOUT),
        .CLKOUT0(CLKOUT0),
        .CLKOUT1(CLKOUT1),
        .CLKOUT2(CLKOUT2),
        .CLKOUT3(CLKOUT3),
        .CLKOUT4(CLKOUT4),
        .CLKOUT5(CLKOUT5),
        .LOCKED(LOCKED)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            RST = 1;
            PWRDWN = 0;
            #100;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Power Down State", test_num);
            RST = 0;
            PWRDWN = 1;
            #100;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Normal Operation - Locking", test_num);
            RST = 1;
            PWRDWN = 0;
            #20;
            RST = 0;



            #500;





            #1;






            check_outputs(CLKFBOUT, CLKOUT0, CLKOUT1, CLKOUT2, CLKOUT3, CLKOUT4, CLKOUT5, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Loss of Lock on Reset", test_num);

            RST = 0;
            PWRDWN = 0;
            #100;

            RST = 1;
            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
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
        input expected_CLKFBOUT;
        input expected_CLKOUT0;
        input expected_CLKOUT1;
        input expected_CLKOUT2;
        input expected_CLKOUT3;
        input expected_CLKOUT4;
        input expected_CLKOUT5;
        input expected_LOCKED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CLKFBOUT === (expected_CLKFBOUT ^ CLKFBOUT ^ expected_CLKFBOUT) &&
                expected_CLKOUT0 === (expected_CLKOUT0 ^ CLKOUT0 ^ expected_CLKOUT0) &&
                expected_CLKOUT1 === (expected_CLKOUT1 ^ CLKOUT1 ^ expected_CLKOUT1) &&
                expected_CLKOUT2 === (expected_CLKOUT2 ^ CLKOUT2 ^ expected_CLKOUT2) &&
                expected_CLKOUT3 === (expected_CLKOUT3 ^ CLKOUT3 ^ expected_CLKOUT3) &&
                expected_CLKOUT4 === (expected_CLKOUT4 ^ CLKOUT4 ^ expected_CLKOUT4) &&
                expected_CLKOUT5 === (expected_CLKOUT5 ^ CLKOUT5 ^ expected_CLKOUT5) &&
                expected_LOCKED === (expected_LOCKED ^ LOCKED ^ expected_LOCKED)) begin
                $display("PASS");
                $display("  Outputs: CLKFBOUT=%b, CLKOUT0=%b, CLKOUT1=%b, CLKOUT2=%b, CLKOUT3=%b, CLKOUT4=%b, CLKOUT5=%b, LOCKED=%b",
                         CLKFBOUT, CLKOUT0, CLKOUT1, CLKOUT2, CLKOUT3, CLKOUT4, CLKOUT5, LOCKED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CLKFBOUT=%b, CLKOUT0=%b, CLKOUT1=%b, CLKOUT2=%b, CLKOUT3=%b, CLKOUT4=%b, CLKOUT5=%b, LOCKED=%b",
                         expected_CLKFBOUT, expected_CLKOUT0, expected_CLKOUT1, expected_CLKOUT2, expected_CLKOUT3, expected_CLKOUT4, expected_CLKOUT5, expected_LOCKED);
                $display("  Got:      CLKFBOUT=%b, CLKOUT0=%b, CLKOUT1=%b, CLKOUT2=%b, CLKOUT3=%b, CLKOUT4=%b, CLKOUT5=%b, LOCKED=%b",
                         CLKFBOUT, CLKOUT0, CLKOUT1, CLKOUT2, CLKOUT3, CLKOUT4, CLKOUT5, LOCKED);
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
