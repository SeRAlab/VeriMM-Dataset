`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] exp;
    reg [9:0] man;
    wire [15:0] lin;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .exp(exp),
        .man(man),
        .lin(lin)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        man = 10'sh000; exp = 3'd0;
        #10;
        #1;

        check_outputs(16'sh0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        man = 10'sh001; exp = 3'd0;
        #10;
        #1;

        check_outputs(16'sh0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        man = 10'sh001; exp = 3'd4;
        #10;
        #1;

        check_outputs(16'sh0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        man = 10'sh1FF; exp = 3'd0;
        #10;
        #1;

        check_outputs(16'sh01FF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        man = 10'sh1FF; exp = 3'd6;
        #10;
        #1;

        check_outputs(16'sh7FC0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        man = 10'sh3FF; exp = 3'd0;
        #10;
        #1;

        check_outputs(16'shFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        man = 10'sh3FF; exp = 3'd7;
        #10;
        #1;

        check_outputs(16'shFF80);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        man = 10'sh200; exp = 3'd0;
        #10;
        #1;

        check_outputs(16'shFE00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        man = 10'sh200; exp = 3'd6;
        #10;
        #1;

        check_outputs(16'sh8000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        man = 10'sd123; exp = 3'd3;
        #10;
        #1;

        check_outputs(16'sd984);
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
        input [15:0] expected_lin;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lin === (expected_lin ^ lin ^ expected_lin)) begin
                $display("PASS");
                $display("  Outputs: lin=%h",
                         lin);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lin=%h",
                         expected_lin);
                $display("  Got:      lin=%h",
                         lin);
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
