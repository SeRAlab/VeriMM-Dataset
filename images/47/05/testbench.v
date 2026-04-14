`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg en;
    reg reset;
    wire o1;
    wire o2;
    wire o3;
    wire o4;
    wire o5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .en(en),
        .reset(reset),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4),
        .o5(o5)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing initial reset state", test_num);

            reset = 1;
            en = 0;
            a = 0;
            b = 0;
            c = 0;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing data load with en=1", test_num);

            reset = 1;
            #10;
            reset = 0;
            en = 1;
            a = 1;
            b = 0;
            c = 1;
            #10;

            #1;


            check_outputs(1, 0, 1, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing different data pattern load", test_num);

            reset = 1;
            #10;
            reset = 0;
            en = 1;
            a = 0;
            b = 1;
            c = 0;
            #10;

            #1;


            check_outputs(0, 1, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing data hold with en=0", test_num);

            reset = 1;
            #10;
            reset = 0;

            en = 1;
            a = 1;
            b = 1;
            c = 0;
            #10;

            en = 0;
            a = 0;
            b = 0;
            c = 1;
            #10;

            #1;


            check_outputs(1, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing reset priority during active load", test_num);

            reset = 1;
            #10;
            reset = 0;

            en = 1;
            a = 1;
            b = 1;
            c = 1;
            #10;

            reset = 1;
            #10;

            #1;


            check_outputs(0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing high-to-low transition clearing", test_num);

            reset = 1;
            #10;
            reset = 0;
            en = 1;
            a = 1;
            b = 1;
            c = 1;
            #10;

            reset = 1;
            #10;
            #1;

            check_outputs(0, 0, 0, 0, 1);
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
        input expected_o1;
        input expected_o2;
        input expected_o3;
        input expected_o4;
        input expected_o5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4) &&
                expected_o5 === (expected_o5 ^ o5 ^ expected_o5)) begin
                $display("PASS");
                $display("  Outputs: o1=%b, o2=%b, o3=%b, o4=%b, o5=%b",
                         o1, o2, o3, o4, o5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o1=%b, o2=%b, o3=%b, o4=%b, o5=%b",
                         expected_o1, expected_o2, expected_o3, expected_o4, expected_o5);
                $display("  Got:      o1=%b, o2=%b, o3=%b, o4=%b, o5=%b",
                         o1, o2, o3, o4, o5);
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
