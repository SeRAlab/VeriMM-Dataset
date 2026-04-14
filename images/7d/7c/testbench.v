`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] din1;
    reg [2:0] din2;
    wire [5:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din1(din1),
        .din2(din2),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = 1;
        din1 = 3'sd0;
        din2 = 3'sd0;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        din1 = 3'sd1;
        din2 = 3'sd1;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        din1 = 3'sd3;
        din2 = 3'sd3;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        din1 = -3'sd4;
        din2 = -3'sd4;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        din1 = 3'sd3;
        din2 = -3'sd4;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(-6'sd12);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        din1 = -3'sd4;
        din2 = 3'sd3;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(-6'sd12);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        din1 = -3'sd1;
        din2 = -3'sd1;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        din1 = -3'sd1;
        din2 = 3'sd2;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(-6'sd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        din1 = 3'sd2;
        din2 = -3'sd4;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(-6'sd8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        din1 = 3'sd0;
        din2 = -3'sd4;
        $display("Testcase %03d: din1=%d, din2=%d", test_num, din1, din2);
        #1;

        check_outputs(6'sd0);
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
        input [5:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
