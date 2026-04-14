`timescale 1ns/1ps

module morphological_erosion_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] img;
    wire eroded_pixel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    morphological_erosion dut (
        .img(img),
        .eroded_pixel(eroded_pixel)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Full Match - All input pixels are 1");
            img = 9'b111_111_111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All input pixels are 0");
            img = 9'b000_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Single pixel missing (LSB bit 0 is 0)");
            img = 9'b111_111_110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Single pixel missing (Center bit 4 is 0)");
            img = 9'b111_101_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Single pixel missing (MSB bit 8 is 0)");
            img = 9'b011_111_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Only center pixel is 1");
            img = 9'b000_010_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Checkerboard pattern (Alternate 1s and 0s)");
            img = 9'b101_010_101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Boundary test - only top row is 1");
            img = 9'b111_000_000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Boundary test - only bottom row is 1");
            img = 9'b000_000_111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case 010: Boundary test - only middle column is 1");
            img = 9'b010_010_010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("morphological_erosion Testbench");
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
        input expected_eroded_pixel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_eroded_pixel === (expected_eroded_pixel ^ eroded_pixel ^ expected_eroded_pixel)) begin
                $display("PASS");
                $display("  Outputs: eroded_pixel=%b",
                         eroded_pixel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: eroded_pixel=%b",
                         expected_eroded_pixel);
                $display("  Got:      eroded_pixel=%b",
                         eroded_pixel);
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
