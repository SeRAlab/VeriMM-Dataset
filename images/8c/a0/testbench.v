`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg EMEMRAMCLK;
    reg FCLK;
    reg SVSTOP;
    wire dummy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EMEMRAMCLK(EMEMRAMCLK),
        .FCLK(FCLK),
        .SVSTOP(SVSTOP),
        .dummy(dummy)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SVSTOP low, Clocks low", test_num);
            SVSTOP = 1'b0;
            FCLK = 1'b0;
            EMEMRAMCLK = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SVSTOP high, Clocks low", test_num);
            SVSTOP = 1'b1;
            FCLK = 1'b0;
            EMEMRAMCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SVSTOP low, FCLK toggling", test_num);
            SVSTOP = 1'b0;
            EMEMRAMCLK = 1'b0;
            FCLK = 1'b1; #5;
            FCLK = 1'b0; #5;
            FCLK = 1'b1; #5;
            FCLK = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: SVSTOP high, EMEMRAMCLK toggling", test_num);
            SVSTOP = 1'b1;
            FCLK = 1'b0;
            EMEMRAMCLK = 1'b1; #5;
            EMEMRAMCLK = 1'b0; #5;
            EMEMRAMCLK = 1'b1; #5;
            EMEMRAMCLK = 1'b0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Concurrent clock activity and SVSTOP transition", test_num);
            SVSTOP = 1'b0;
            FCLK = 1'b1;
            EMEMRAMCLK = 1'b1;
            #10;
            SVSTOP = 1'b1;
            FCLK = 1'b0;
            EMEMRAMCLK = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verification of high-impedance or undefined state passing (if applicable)", test_num);

            SVSTOP = 1'bx;
            FCLK = 1'b0;
            EMEMRAMCLK = 1'b0;
            #1;

            check_outputs(1'bx);
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
        input expected_dummy;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dummy === (expected_dummy ^ dummy ^ expected_dummy)) begin
                $display("PASS");
                $display("  Outputs: dummy=%b",
                         dummy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dummy=%b",
                         expected_dummy);
                $display("  Got:      dummy=%b",
                         dummy);
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
