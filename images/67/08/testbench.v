`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] c;
    reg [10:0] data;
    wire [4:0] next_crc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .data(data),
        .next_crc(next_crc)
    );
    task testcase001;

    begin
        test_num = 1;
        c = 5'h00;
        data = 11'h000;

        #1;


        check_outputs(5'h1F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        c = 5'h1F;
        data = 11'h7FF;

        #1;


        check_outputs(5'h1A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        c = 5'h00;
        data = 11'h001;
        #1;

        check_outputs(5'h1E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        c = 5'h00;
        data = 11'h400;
        #1;

        check_outputs(5'h02);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        c = 5'h1F;
        data = 11'h355;
        #1;

        check_outputs(5'h08);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        c = 5'h0A;
        data = 11'h123;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        c = 5'h10;
        data = 11'h000;
        #1;

        check_outputs(5'h1E);
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
        input [4:0] expected_next_crc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_next_crc === (expected_next_crc ^ next_crc ^ expected_next_crc)) begin
                $display("PASS");
                $display("  Outputs: next_crc=%h",
                         next_crc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: next_crc=%h",
                         expected_next_crc);
                $display("  Got:      next_crc=%h",
                         next_crc);
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
