`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg P1;
    reg P10;
    reg P11;
    reg P12;
    reg P13;
    reg P14;
    reg P15;
    reg P16;
    reg P2;
    reg P3;
    reg P4;
    reg P7;
    reg P8;
    reg P9;
    wire P5;
    wire P6;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .P1(P1),
        .P10(P10),
        .P11(P11),
        .P12(P12),
        .P13(P13),
        .P14(P14),
        .P15(P15),
        .P16(P16),
        .P2(P2),
        .P3(P3),
        .P4(P4),
        .P7(P7),
        .P8(P8),
        .P9(P9),
        .P5(P5),
        .P6(P6)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select P1 (000), Data=1, Enabled", test_num);

            P16 = 1; P8 = 1; P7 = 1;

            P11 = 0; P10 = 0; P9 = 0;

            P1 = 1; P2 = 0; P3 = 0; P4 = 0;
            P12 = 0; P13 = 0; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select P2 (001), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 0; P10 = 0; P9 = 1;
            P1 = 0; P2 = 1; P3 = 0; P4 = 0;
            P12 = 0; P13 = 0; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select P3 (010), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 0; P10 = 1; P9 = 0;
            P1 = 0; P2 = 0; P3 = 1; P4 = 0;
            P12 = 0; P13 = 0; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select P4 (011), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 0; P10 = 1; P9 = 1;
            P1 = 0; P2 = 0; P3 = 0; P4 = 1;
            P12 = 0; P13 = 0; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select P12 (100), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 1; P10 = 0; P9 = 0;
            P1 = 0; P2 = 0; P3 = 0; P4 = 0;
            P12 = 1; P13 = 0; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select P13 (101), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 1; P10 = 0; P9 = 1;
            P1 = 0; P2 = 0; P3 = 0; P4 = 0;
            P12 = 0; P13 = 1; P14 = 0; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select P14 (110), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 1; P10 = 1; P9 = 0;
            P1 = 0; P2 = 0; P3 = 0; P4 = 0;
            P12 = 0; P13 = 0; P14 = 1; P15 = 0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select P15 (111), Data=1, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 1; P10 = 1; P9 = 1;
            P1 = 0; P2 = 0; P3 = 0; P4 = 0;
            P12 = 0; P13 = 0; P14 = 0; P15 = 1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Select P1 (000), Data=0, Enabled", test_num);
            P16 = 1; P8 = 1; P7 = 1;

            P11 = 0; P10 = 0; P9 = 0;
            P1 = 0; P2 = 1; P3 = 1; P4 = 1;
            P12 = 1; P13 = 1; P14 = 1; P15 = 1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Select P1 (000), Data=1, Disabled (P16=0)", test_num);

            P16 = 0; P8 = 1; P7 = 1;
            P11 = 0; P10 = 0; P9 = 0;
            P1 = 1;

            #1;


            check_outputs(1'b0, 1'b1);
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
        input expected_P5;
        input expected_P6;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P5 === (expected_P5 ^ P5 ^ expected_P5) &&
                expected_P6 === (expected_P6 ^ P6 ^ expected_P6)) begin
                $display("PASS");
                $display("  Outputs: P5=%b, P6=%b",
                         P5, P6);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P5=%b, P6=%b",
                         expected_P5, expected_P6);
                $display("  Got:      P5=%b, P6=%b",
                         P5, P6);
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
