`timescale 1ns/1ps

module morphological_dilation_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] image;
    wire dilated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_dilation dut (
        .image(image),
        .dilated(dilated)
    );
    task testcase001;

        begin
            $display("Test Case 001: All pixels 0");
            test_num = 1;
            image = 9'b000_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Single pixel (index 0) set to 1");
            test_num = 2;
            image = 9'b000_000_001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Center pixel (index 4) set to 1");
            test_num = 3;
            image = 9'b000_010_000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Corner pixel (index 8) set to 1");
            test_num = 4;
            image = 9'b100_000_000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: All pixels set to 1");
            test_num = 5;
            image = 9'b111_111_111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Checkerboard pattern");
            test_num = 6;
            image = 9'b101_010_101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Middle row only");
            test_num = 7;
            image = 9'b000_111_000;
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
        $display("morphological_dilation Testbench");
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
        input expected_dilated;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dilated === (expected_dilated ^ dilated ^ expected_dilated)) begin
                $display("PASS");
                $display("  Outputs: dilated=%b",
                         dilated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dilated=%b",
                         expected_dilated);
                $display("  Got:      dilated=%b",
                         dilated);
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
