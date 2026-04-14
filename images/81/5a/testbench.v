`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg din0;
    reg din1;
    reg din2;
    reg din3;
    wire dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .din2(din2),
        .din3(din3),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            din3 = 0; din2 = 0; din1 = 0; din0 = 0;
            #1;

            check_outputs(0 ^ 0 ^ 0 ^ 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            din3 = 0; din2 = 0; din1 = 0; din0 = 1;
            #1;

            check_outputs(0 ^ 0 ^ 0 ^ 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            din3 = 0; din2 = 0; din1 = 1; din0 = 0;
            #1;

            check_outputs(0 ^ 0 ^ 1 ^ 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            din3 = 0; din2 = 0; din1 = 1; din0 = 1;
            #1;

            check_outputs(0 ^ 0 ^ 1 ^ 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            din3 = 0; din2 = 1; din1 = 0; din0 = 0;
            #1;

            check_outputs(0 ^ 1 ^ 0 ^ 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            din3 = 0; din2 = 1; din1 = 0; din0 = 1;
            #1;

            check_outputs(0 ^ 1 ^ 0 ^ 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            din3 = 0; din2 = 1; din1 = 1; din0 = 0;
            #1;

            check_outputs(0 ^ 1 ^ 1 ^ 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            din3 = 0; din2 = 1; din1 = 1; din0 = 1;
            #1;

            check_outputs(0 ^ 1 ^ 1 ^ 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            din3 = 1; din2 = 0; din1 = 0; din0 = 0;
            #1;

            check_outputs(1 ^ 0 ^ 0 ^ 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            din3 = 1; din2 = 0; din1 = 0; din0 = 1;
            #1;

            check_outputs(1 ^ 0 ^ 0 ^ 1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            din3 = 1; din2 = 0; din1 = 1; din0 = 0;
            #1;

            check_outputs(1 ^ 0 ^ 1 ^ 0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            din3 = 1; din2 = 0; din1 = 1; din0 = 1;
            #1;

            check_outputs(1 ^ 0 ^ 1 ^ 1);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            din3 = 1; din2 = 1; din1 = 0; din0 = 0;
            #1;

            check_outputs(1 ^ 1 ^ 0 ^ 0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            din3 = 1; din2 = 1; din1 = 0; din0 = 1;
            #1;

            check_outputs(1 ^ 1 ^ 0 ^ 1);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            din3 = 1; din2 = 1; din1 = 1; din0 = 0;
            #1;

            check_outputs(1 ^ 1 ^ 1 ^ 0);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            din3 = 1; din2 = 1; din1 = 1; din0 = 1;
            #1;

            check_outputs(1 ^ 1 ^ 1 ^ 1);
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
        input expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%b",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b",
                         expected_dout);
                $display("  Got:      dout=%b",
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
