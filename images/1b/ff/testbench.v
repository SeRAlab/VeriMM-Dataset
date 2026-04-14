`timescale 1ns/1ps

module hough_transform_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] binary_image;
    wire [179:0] hough_space;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hough_transform dut (
        .binary_image(binary_image),
        .hough_space(hough_space)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Empty Image");
            binary_image = 64'h0000000000000000;
            #1;

            check_outputs(180'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Vertical Line (Col 0)");
            binary_image = 64'h0101010101010101;
            #1;

            check_outputs(180'h1 << 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Horizontal Line (Row 0)");
            binary_image = 64'h00000000000000FF;
            #1;

            check_outputs(180'h1 << 90);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Main Diagonal (x=y)");
            binary_image = 64'h8040201008040201;
            #1;

            check_outputs(180'h1 << 135);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Anti-Diagonal (x+y=7)");
            binary_image = 64'h0102040810204080;
            #1;

            check_outputs(180'h1 << 45);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Multiple Lines (Col 7 and Row 7)");
            binary_image = 64'hFF80808080808080;
            #1;

            check_outputs((180'h1 << 0) | (180'h1 << 90));
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Single Points (Noise)");
            binary_image = 64'h0000001000010000;
            #1;

            check_outputs(180'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase 008: Horizontal Line (Row 4)");
            binary_image = 64'h00000000FF000000;
            #1;

            check_outputs(180'h1 << 90);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase 009: Vertical Line (Col 3)");
            binary_image = 64'h0808080808080808;
            #1;

            check_outputs(180'h1 << 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase 010: Full Image");
            binary_image = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs((180'h1 << 0) | (180'h1 << 90) | (180'h1 << 45) | (180'h1 << 135));
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hough_transform Testbench");
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
        input [179:0] expected_hough_space;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hough_space === (expected_hough_space ^ hough_space ^ expected_hough_space)) begin
                $display("PASS");
                $display("  Outputs: hough_space=%h",
                         hough_space);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hough_space=%h",
                         expected_hough_space);
                $display("  Got:      hough_space=%h",
                         hough_space);
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
