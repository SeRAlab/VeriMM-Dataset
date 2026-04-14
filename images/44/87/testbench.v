`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    wire [2:0] EN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .EN(EN)
    );
    task testcase001;

    begin
        test_num = 1;
        D = 8'b1000_0000;
        #1;

        check_outputs(3'd7);
    end

task


    task testcase002;
    begin
        test_num = 2;
        D = 8'b0100_0000;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        D = 8'b0010_0000;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        D = 8'b1100_0000;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        D = 8'b0110_0000;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        D = 8'b1110_0000;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        D = 8'b0001_1111;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        D = 8'b1111_1111;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        D = 8'b0010_1111;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        D = 8'b0000_0000;
        #1;

        check_outputs(3'd0);
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
        input [2:0] expected_EN;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EN === (expected_EN ^ EN ^ expected_EN)) begin
                $display("PASS");
                $display("  Outputs: EN=%h",
                         EN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%h",
                         expected_EN);
                $display("  Got:      EN=%h",
                         EN);
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
