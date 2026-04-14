`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] nybble;
    wire [7:0] digit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nybble(nybble),
        .digit(digit)
    );
    task testcase001;

        begin
            test_num = 1;
            nybble = 4'h0;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            nybble = 4'h1;
            #1;

            check_outputs(8'h31);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            nybble = 4'h5;
            #1;

            check_outputs(8'h35);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            nybble = 4'h9;
            #1;

            check_outputs(8'h39);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            nybble = 4'hA;
            #1;

            check_outputs(8'h41);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            nybble = 4'hB;
            #1;

            check_outputs(8'h42);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            nybble = 4'hC;
            #1;

            check_outputs(8'h43);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            nybble = 4'hD;
            #1;

            check_outputs(8'h44);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            nybble = 4'hE;
            #1;

            check_outputs(8'h45);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            nybble = 4'hF;
            #1;

            check_outputs(8'h46);
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
        input [7:0] expected_digit;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digit === (expected_digit ^ digit ^ expected_digit)) begin
                $display("PASS");
                $display("  Outputs: digit=%h",
                         digit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digit=%h",
                         expected_digit);
                $display("  Got:      digit=%h",
                         digit);
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
