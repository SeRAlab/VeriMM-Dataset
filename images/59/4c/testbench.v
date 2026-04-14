`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg k;
    reg l;
    reg m;
    reg n;
    wire o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .k(k),
        .l(l),
        .m(m),
        .n(n),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        k = 0; l = 0; m = 1; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        k = 1; l = 0; m = 1; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        k = 1; l = 0; m = 1; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        k = 1; l = 1; m = 1; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        k = 1; l = 1; m = 0; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        k = 0; l = 0; m = 0; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        k = 1; l = 1; m = 1; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        k = 0; l = 0; m = 0; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        k = 1; l = 0; m = 0; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        k = 0; l = 0; m = 1; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        k = 0; l = 1; m = 1; n = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        k = 0; l = 1; m = 0; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        k = 0; l = 1; m = 1; n = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        k = 0; l = 1; m = 0; n = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        k = 1; l = 0; m = 0; n = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        k = 1; l = 1; m = 0; n = 1;
        #1;

        check_outputs(1);
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
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%b",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%b",
                         expected_o);
                $display("  Got:      o=%b",
                         o);
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
