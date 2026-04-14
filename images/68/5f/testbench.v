`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg green1;
    reg pw_1;
    reg pw_10;
    reg pw_2;
    reg pw_3;
    reg pw_4;
    reg pw_5;
    reg pw_6;
    reg pw_7;
    reg pw_8;
    reg pw_9;
    reg xiugai;
    wire m1;
    wire m10;
    wire m2;
    wire m3;
    wire m4;
    wire m5;
    wire m6;
    wire m7;
    wire m8;
    wire m9;
    wire n1;
    wire n10;
    wire n2;
    wire n3;
    wire n4;
    wire n5;
    wire n6;
    wire n7;
    wire n8;
    wire n9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .green1(green1),
        .pw_1(pw_1),
        .pw_10(pw_10),
        .pw_2(pw_2),
        .pw_3(pw_3),
        .pw_4(pw_4),
        .pw_5(pw_5),
        .pw_6(pw_6),
        .pw_7(pw_7),
        .pw_8(pw_8),
        .pw_9(pw_9),
        .xiugai(xiugai),
        .m1(m1),
        .m10(m10),
        .m2(m2),
        .m3(m3),
        .m4(m4),
        .m5(m5),
        .m6(m6),
        .m7(m7),
        .m8(m8),
        .m9(m9),
        .n1(n1),
        .n10(n10),
        .n2(n2),
        .n3(n3),
        .n4(n4),
        .n5(n5),
        .n6(n6),
        .n7(n7),
        .n8(n8),
        .n9(n9)
    );
    task testcase001;

        begin
            $display("Testcase 001: Both controls High (Route to N), All inputs High");
            test_num = test_num + 1;

            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;


            green1 = 1; xiugai = 1;
            pw_1 = 1; pw_2 = 1; pw_3 = 1; pw_4 = 1; pw_5 = 1;
            pw_6 = 1; pw_7 = 1; pw_8 = 1; pw_9 = 1; pw_10 = 1;



            #1;




            check_outputs(0,0,0,0,0,0,0,0,0,0, 1,1,1,1,1,1,1,1,1,1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: green1 Low (Route to M), All inputs High");
            test_num = test_num + 1;
            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;

            green1 = 0; xiugai = 1;
            pw_1 = 1; pw_2 = 1; pw_3 = 1; pw_4 = 1; pw_5 = 1;
            pw_6 = 1; pw_7 = 1; pw_8 = 1; pw_9 = 1; pw_10 = 1;


            #1;



            check_outputs(1,1,1,1,1,1,1,1,1,1, 0,0,0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: xiugai Low (Route to M), All inputs High");
            test_num = test_num + 1;
            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;

            green1 = 1; xiugai = 0;
            pw_1 = 1; pw_2 = 1; pw_3 = 1; pw_4 = 1; pw_5 = 1;
            pw_6 = 1; pw_7 = 1; pw_8 = 1; pw_9 = 1; pw_10 = 1;


            #1;



            check_outputs(1,1,1,1,1,1,1,1,1,1, 0,0,0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Both Low (Route to M), All inputs High");
            test_num = test_num + 1;
            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;

            green1 = 0; xiugai = 0;
            pw_1 = 1; pw_2 = 1; pw_3 = 1; pw_4 = 1; pw_5 = 1;
            pw_6 = 1; pw_7 = 1; pw_8 = 1; pw_9 = 1; pw_10 = 1;


            #1;



            check_outputs(1,1,1,1,1,1,1,1,1,1, 0,0,0,0,0,0,0,0,0,0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Both controls High (Route to N), Mixed inputs 1010101010");
            test_num = test_num + 1;
            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;

            green1 = 1; xiugai = 1;
            pw_1 = 1; pw_2 = 0; pw_3 = 1; pw_4 = 0; pw_5 = 1;
            pw_6 = 0; pw_7 = 1; pw_8 = 0; pw_9 = 1; pw_10 = 0;



            #1;




            check_outputs(0,0,0,0,0,0,0,0,0,0, 1,0,0,1,0,1,0,1,0,1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: xiugai Low (Route to M), Mixed inputs 1100110011");
            test_num = test_num + 1;
            green1 = 0; xiugai = 0;
            pw_1 = 0; pw_2 = 0; pw_3 = 0; pw_4 = 0; pw_5 = 0;
            pw_6 = 0; pw_7 = 0; pw_8 = 0; pw_9 = 0; pw_10 = 0;
            #5;

            green1 = 1; xiugai = 0;
            pw_1 = 1; pw_2 = 1; pw_3 = 0; pw_4 = 0; pw_5 = 1;
            pw_6 = 1; pw_7 = 0; pw_8 = 0; pw_9 = 1; pw_10 = 1;



            #1;




            check_outputs(1,1,1,0,0,1,1,0,0,1, 0,0,0,0,0,0,0,0,0,0);
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
        input expected_m1;
        input expected_m10;
        input expected_m2;
        input expected_m3;
        input expected_m4;
        input expected_m5;
        input expected_m6;
        input expected_m7;
        input expected_m8;
        input expected_m9;
        input expected_n1;
        input expected_n10;
        input expected_n2;
        input expected_n3;
        input expected_n4;
        input expected_n5;
        input expected_n6;
        input expected_n7;
        input expected_n8;
        input expected_n9;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_m1 === (expected_m1 ^ m1 ^ expected_m1) &&
                expected_m10 === (expected_m10 ^ m10 ^ expected_m10) &&
                expected_m2 === (expected_m2 ^ m2 ^ expected_m2) &&
                expected_m3 === (expected_m3 ^ m3 ^ expected_m3) &&
                expected_m4 === (expected_m4 ^ m4 ^ expected_m4) &&
                expected_m5 === (expected_m5 ^ m5 ^ expected_m5) &&
                expected_m6 === (expected_m6 ^ m6 ^ expected_m6) &&
                expected_m7 === (expected_m7 ^ m7 ^ expected_m7) &&
                expected_m8 === (expected_m8 ^ m8 ^ expected_m8) &&
                expected_m9 === (expected_m9 ^ m9 ^ expected_m9) &&
                expected_n1 === (expected_n1 ^ n1 ^ expected_n1) &&
                expected_n10 === (expected_n10 ^ n10 ^ expected_n10) &&
                expected_n2 === (expected_n2 ^ n2 ^ expected_n2) &&
                expected_n3 === (expected_n3 ^ n3 ^ expected_n3) &&
                expected_n4 === (expected_n4 ^ n4 ^ expected_n4) &&
                expected_n5 === (expected_n5 ^ n5 ^ expected_n5) &&
                expected_n6 === (expected_n6 ^ n6 ^ expected_n6) &&
                expected_n7 === (expected_n7 ^ n7 ^ expected_n7) &&
                expected_n8 === (expected_n8 ^ n8 ^ expected_n8) &&
                expected_n9 === (expected_n9 ^ n9 ^ expected_n9)) begin
                $display("PASS");
                $display("  Outputs: m1=%b, m10=%b, m2=%b, m3=%b, m4=%b, m5=%b, m6=%b, m7=%b, m8=%b, m9=%b, n1=%b, n10=%b, n2=%b, n3=%b, n4=%b, n5=%b, n6=%b, n7=%b, n8=%b, n9=%b",
                         m1, m10, m2, m3, m4, m5, m6, m7, m8, m9, n1, n10, n2, n3, n4, n5, n6, n7, n8, n9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m1=%b, m10=%b, m2=%b, m3=%b, m4=%b, m5=%b, m6=%b, m7=%b, m8=%b, m9=%b, n1=%b, n10=%b, n2=%b, n3=%b, n4=%b, n5=%b, n6=%b, n7=%b, n8=%b, n9=%b",
                         expected_m1, expected_m10, expected_m2, expected_m3, expected_m4, expected_m5, expected_m6, expected_m7, expected_m8, expected_m9, expected_n1, expected_n10, expected_n2, expected_n3, expected_n4, expected_n5, expected_n6, expected_n7, expected_n8, expected_n9);
                $display("  Got:      m1=%b, m10=%b, m2=%b, m3=%b, m4=%b, m5=%b, m6=%b, m7=%b, m8=%b, m9=%b, n1=%b, n10=%b, n2=%b, n3=%b, n4=%b, n5=%b, n6=%b, n7=%b, n8=%b, n9=%b",
                         m1, m10, m2, m3, m4, m5, m6, m7, m8, m9, n1, n10, n2, n3, n4, n5, n6, n7, n8, n9);
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
