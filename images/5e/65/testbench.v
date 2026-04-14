`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (

    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Initialization to 1", test_num);
            reset = 1; r0_in = 3'sd0; r1_in = 3'sd0;
            @(posedge clk);
            #2 reset = 0;
            r0_in = 3'sd1; r1_in = 3'sd1;
            @(posedge clk);

            expected_as_wr = 5'b00001;
            #1;

            check_outputs();
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Setting values to 0", test_num);
            reset = 1; @(posedge clk); #2 reset = 0;
            r0_in = 3'sd0; r1_in = 3'sd0;
            @(posedge clk);
            expected_as_wr = 5'b00000;
            #1;

            check_outputs();
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Negative R0 (-1), Positive R1 (2)", test_num);
            reset = 1; @(posedge clk); #2 reset = 0;
            r0_in = -1; r1_in = 2;
            @(posedge clk);

            expected_as_wr = 5'b11010;
            #1;

            check_outputs();
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Positive R0 (3), Negative R1 (-2)", test_num);
            reset = 1; @(posedge clk); #2 reset = 0;
            r0_in = 3; r1_in = -2;
            @(posedge clk);

            expected_as_wr = 5'b00110;
            #1;

            check_outputs();
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Both Negative (-4, -4)", test_num);
            reset = 1; @(posedge clk); #2 reset = 0;
            r0_in = -4; r1_in = -4;
            @(posedge clk);

            expected_as_wr = 5'b11100;
            #1;

            check_outputs();
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max Positive (3, 3)", test_num);
            reset = 1; @(posedge clk); #2 reset = 0;
            r0_in = 3; r1_in = 3;
            @(posedge clk);
            expected_as_wr = 5'b00011;
            #1;

            check_outputs();
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
