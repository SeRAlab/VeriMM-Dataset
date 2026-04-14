`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ARST;
    reg [1:0] D;
    reg EN;
    wire [1:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ARST(ARST),
        .D(D),
        .EN(EN),
        .Q(Q)
    );
    task testcase001;

        begin
            test_num = 1;

            ARST = 1; EN = 0; D = 2'b00;
            #10;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;

            ARST = 1; EN = 0; D = 2'b00;
            #5;
            ARST = 0;
            #5;
            EN = 1;
            D = 2'b11;
            #10;

            #1;


            check_outputs(2'b11);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;

            ARST = 1; EN = 0; D = 2'b00;
            #5;
            ARST = 0;
            EN = 1; D = 2'b10;
            #5;
            EN = 0;
            D = 2'b01;
            #10;

            #1;


            check_outputs(2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;

            ARST = 1; EN = 1; D = 2'b11;
            #10;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;

            ARST = 1; EN = 0; D = 2'b00;
            #5;
            ARST = 0;
            EN = 1; D = 2'b01;
            #5;
            EN = 0;
            #5;
            ARST = 1;
            #10;

            #1;


            check_outputs(2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;

            ARST = 1; EN = 0; D = 2'b00;
            #5;
            ARST = 0;
            EN = 1; D = 2'b11;
            #5;
            D = 2'b01;
            #10;

            #1;


            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;

            ARST = 1; EN = 0; D = 2'b11;
            #10;

            #1;


            check_outputs(2'b00);
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
        input [1:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
