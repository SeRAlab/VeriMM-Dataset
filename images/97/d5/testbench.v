`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] SW;
    wire [7:0] LEDG;
    wire [17:0] LEDR;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SW(SW),
        .LEDG(LEDG),
        .LEDR(LEDR)
    );
    task testcase001;

    begin
        test_num = 1;
        SW = 18'b000_000000000000_101;
        #10;
        #1;

        check_outputs(8'h05, 18'h00005);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        SW = 18'b001_000000000_110_000;
        #10;
        #1;

        check_outputs(8'h06, 18'h08030);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        SW = 18'b010_000000_011_000000;
        #10;
        #1;

        check_outputs(8'h03, 18'h100C0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        SW = 18'b011_000_111_000000000;
        #10;
        #1;

        check_outputs(8'h07, 18'h18E00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        SW = 18'b100_001_000000000000;
        #10;
        #1;

        check_outputs(8'h01, 18'h21000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        SW = 18'b101_010_101_010_101_010;
        #10;
        #1;

        check_outputs(8'h05, 18'h2AAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        SW = 18'b110_000000000000000;
        #10;


        #1;



        check_outputs(8'h06, 18'h30000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        SW = 18'h3FFFF;
        #10;

        #1;


        check_outputs(8'h07, 18'h3FFFF);
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
        input [7:0] expected_LEDG;
        input [17:0] expected_LEDR;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEDG === (expected_LEDG ^ LEDG ^ expected_LEDG) &&
                expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR)) begin
                $display("PASS");
                $display("  Outputs: LEDG=%h, LEDR=%h",
                         LEDG, LEDR);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDG=%h, LEDR=%h",
                         expected_LEDG, expected_LEDR);
                $display("  Got:      LEDG=%h, LEDR=%h",
                         LEDG, LEDR);
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
