`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] SEin;
    wire [63:0] SEout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .SEin(SEin),
        .SEout(SEout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero input", test_num);
            SEin = 9'b0_0000_0000;
            #1;

            check_outputs(64'h0000000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Minimum positive value", test_num);
            SEin = 9'b0_0000_0001;
            #1;

            check_outputs(64'h0000000000000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum positive value (MSB=0)", test_num);
            SEin = 9'b0_1111_1111;
            #1;

            check_outputs(64'h00000000000000FF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: All ones (Negative -1)", test_num);
            SEin = 9'b1_1111_1111;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Minimum negative value", test_num);
            SEin = 9'b1_0000_0000;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFF00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Patterned positive value", test_num);
            SEin = 9'b0_1010_1010;
            #1;

            check_outputs(64'h00000000000000AA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Patterned negative value", test_num);
            SEin = 9'b1_0101_0101;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFF55);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Single bit set below MSB", test_num);
            SEin = 9'b0_1000_0000;
            #1;

            check_outputs(64'h0000000000000080);
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
        input [63:0] expected_SEout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SEout === (expected_SEout ^ SEout ^ expected_SEout)) begin
                $display("PASS");
                $display("  Outputs: SEout=%h",
                         SEout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SEout=%h",
                         expected_SEout);
                $display("  Got:      SEout=%h",
                         SEout);
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
