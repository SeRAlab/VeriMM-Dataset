`timescale 1ns/1ps

module INBUF_MCCC_tb;

    // Testbench signals (combinational circuit)
    reg CLK;
    reg PAD;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    INBUF_MCCC dut (
        .CLK(CLK),
        .PAD(PAD),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Basic logic check - PAD low");

            PAD = 0;
            CLK = 0;
            #10;

            PAD = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Basic logic check - PAD high");

            PAD = 0;
            CLK = 0;
            #10;

            PAD = 1'b1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Check PAD low while CLK is active");

            PAD = 1;
            CLK = 0;
            #10;

            CLK = 1;
            #5;
            PAD = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Check PAD high while CLK is active");

            PAD = 0;
            CLK = 0;
            #10;

            CLK = 1;
            #5;
            PAD = 1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Multi-cycle clock pulse verification");

            PAD = 0;
            CLK = 0;
            #10;

            PAD = 1;
            #5; CLK = 1; #5; CLK = 0;
            #5; CLK = 1; #5; CLK = 0;
            PAD = 0;
            #5; CLK = 1; #5; CLK = 0;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("INBUF_MCCC Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
