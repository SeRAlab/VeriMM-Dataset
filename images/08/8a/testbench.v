`timescale 1ns/1ps

module clock_gating_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg enable;
    wire gated_clk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    clock_gating dut (
        .clk(clk),
        .enable(enable),
        .gated_clk(gated_clk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Clock Gating Disabled - Enable=0, Clock=0");
            enable = 0;
            clk = 0;
            #20;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Clock Gating Disabled - Enable=0, Clock=1");

            enable = 0;
            clk = 0;
            #10;
            clk = 1;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Clock Gating Enabled - Enable=1, Clock=0");

            enable = 1;
            clk = 0;
            #20;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Clock Gating Enabled - Enable=1, Clock=1");

            enable = 1;
            clk = 0;
            #10;
            clk = 1;
            #20;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Clock Gating Transition - Enable 1 to 0");

            enable = 1;
            clk = 0;
            #10;
            clk = 1;
            #10;

            enable = 0;
            #10;
            clk = 0;
            #10;
            clk = 1;
            #10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Clock Gating Transition - Enable 0 to 1");

            enable = 0;
            clk = 1;
            #10;
            clk = 0;
            #10;

            enable = 1;
            #10;
            clk = 1;
            #10;

            #1;


            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("clock_gating Testbench");
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
        input expected_gated_clk;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gated_clk === (expected_gated_clk ^ gated_clk ^ expected_gated_clk)) begin
                $display("PASS");
                $display("  Outputs: gated_clk=%b",
                         gated_clk);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gated_clk=%b",
                         expected_gated_clk);
                $display("  Got:      gated_clk=%b",
                         gated_clk);
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
