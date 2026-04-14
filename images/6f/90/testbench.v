`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] SW;
    wire [9:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .LEDR(LEDR)
    );
    task testcase001;

    begin
        test_num = 1;
        SW = 10'b000_0000001;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        SW = 10'b001_0000010;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        SW = 10'b010_0000100;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        SW = 10'b011_0001000;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        SW = 10'b100_0010000;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        SW = 10'b101_0100000;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        SW = 10'b110_1000000;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        SW = 10'b111_1000000;
        #1;

        check_outputs(10'b0000000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        SW = 10'b000_1111110;
        #1;

        check_outputs(10'b0000000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        SW = 10'b111_0111111;
        #1;

        check_outputs(10'b0000000000);
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
        input [9:0] expected_LEDR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h",
                         LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h",
                         expected_LEDR);
                $display("  Got:      LEDR=%h",
                         LEDR);
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
