`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg inclk0;
    wire c0;
    wire c1;
    wire c2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inclk0(inclk0),
        .c0(c0),
        .c1(c1),
        .c2(c2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Checking initial state (t=1ns)", test_num);


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Checking after first c0 toggle (t=3ns)", test_num);

            #1;
            #1;

            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Checking after first c1 toggle (t=21ns)", test_num);



            #17;
            #1;

            check_outputs(1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Checking after second c1 toggle (t=41ns)", test_num);



            #19;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Checking after first c2 toggle (t=10418ns)", test_num);




            #10376;
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Checking after second c2 toggle (t=20835ns)", test_num);




            #10416;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
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
        input expected_c0;
        input expected_c1;
        input expected_c2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c0 === (expected_c0 ^ c0 ^ expected_c0) &&
                expected_c1 === (expected_c1 ^ c1 ^ expected_c1) &&
                expected_c2 === (expected_c2 ^ c2 ^ expected_c2)) begin
                $display("PASS");
                $display("  Outputs: c0=%b, c1=%b, c2=%b",
                         c0, c1, c2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0=%b, c1=%b, c2=%b",
                         expected_c0, expected_c1, expected_c2);
                $display("  Got:      c0=%b, c1=%b, c2=%b",
                         c0, c1, c2);
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
