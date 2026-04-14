`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg auxValue;
    reg [3:0] value;
    wire [6:0] segments;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .auxValue(auxValue),
        .value(value),
        .segments(segments)
    );
    task testcase001;

    begin
        test_num = 1;
        auxValue = 0; value = 4'h0;
        $display("Test %0d: Hex Mode - Value 0", test_num);
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        auxValue = 0; value = 4'h1;
        $display("Test %0d: Hex Mode - Value 1", test_num);
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        auxValue = 0; value = 4'hA;
        $display("Test %0d: Hex Mode - Value A", test_num);
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        auxValue = 0; value = 4'hF;
        $display("Test %0d: Hex Mode - Value F", test_num);
        #1;

        check_outputs(7'h71);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        auxValue = 1; value = 4'h1;
        $display("Test %0d: Custom Mode - Value 1 (P)", test_num);
        #1;

        check_outputs(7'h73);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        auxValue = 1; value = 4'h2;
        $display("Test %0d: Custom Mode - Value 2 (T)", test_num);
        #1;

        check_outputs(7'h78);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        auxValue = 1; value = 4'h3;
        $display("Test %0d: Custom Mode - Value 3 (R)", test_num);
        #1;

        check_outputs(7'h50);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        auxValue = 1; value = 4'h4;
        $display("Test %0d: Custom Mode - Value 4 (V)", test_num);
        #1;

        check_outputs(7'h1C);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        auxValue = 1; value = 4'h5;
        $display("Test %0d: Custom Mode - Value 5 (H)", test_num);
        #1;

        check_outputs(7'h76);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        auxValue = 1; value = 4'h6;
        $display("Test %0d: Custom Mode - Value 6 (L)", test_num);
        #1;

        check_outputs(7'h38);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: Mode Switch - Val 1 from Hex to Custom", test_num);
        auxValue = 0; value = 4'h1; #5;
        auxValue = 1;
        #1;

        check_outputs(7'h73);
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
        testcase011();
        
        
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
        input [6:0] expected_segments;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_segments === (expected_segments ^ segments ^ expected_segments)) begin
                $display("PASS");
                $display("  Outputs: segments=%h",
                         segments);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: segments=%h",
                         expected_segments);
                $display("  Got:      segments=%h",
                         segments);
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
