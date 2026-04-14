`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] x;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            x = 9'b000_000_000;

            #1;


            check_outputs(9'b000_000_000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Ones", test_num);
            x = 9'b111_111_111;


            #1;



            check_outputs(9'b111_111_111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Alternating pattern 101...", test_num);
            x = 9'b101_010_101;
            #1;

            check_outputs(9'b101_010_101);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Alternating pattern 010...", test_num);
            x = 9'b010_101_010;
            #1;

            check_outputs(9'b010_101_010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Single bit at pos 0", test_num);
            x = 9'b000_000_001;
            #1;

            check_outputs(9'b000_000_000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Single bit at pos 4", test_num);
            x = 9'b000_010_000;
            #1;

            check_outputs(9'b000_000_000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Single bit at pos 8", test_num);
            x = 9'b100_000_000;
            #1;

            check_outputs(9'b000_000_000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Lower nibble active", test_num);
            x = 9'b000_001_111;
            #1;

            check_outputs(9'b000_001_111);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Upper nibble active", test_num);
            x = 9'b111_100_000;
            #1;

            check_outputs(9'b111_100_000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Symmetric pattern", test_num);
            x = 9'b110_010_011;
            #1;

            check_outputs(9'b110_010_011);
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
        input [8:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
