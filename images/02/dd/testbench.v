`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] pixels;
    wire [8:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .pixels(pixels),
        .median(median)
    );
    task testcase001;

    begin
        test_num = 1;
        pixels = 9'b000000000;
        $display("Test Case 001: All Zeros");
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        pixels = 9'b111111111;
        $display("Test Case 002: All Ones");
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        pixels = 9'b000011111;
        $display("Test Case 003: 5 Ones (LSB side)");
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        pixels = 9'b111110000;
        $display("Test Case 004: 5 Ones (MSB side)");
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        pixels = 9'b000111100;
        $display("Test Case 005: 4 Ones");
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        pixels = 9'b101010101;
        $display("Test Case 006: Alternating Bits (5 ones)");
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        pixels = 9'b010101010;
        $display("Test Case 007: Alternating Bits (4 ones)");
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        pixels = 9'b111101111;
        $display("Test Case 008: 8 Ones");
        #1;

        check_outputs(9'h001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        pixels = 9'b000010000;
        $display("Test Case 009: 1 One");
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        pixels = 9'b110110110;
        $display("Test Case 010: 6 Ones");
        #1;

        check_outputs(9'h001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("median_filter Testbench");
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
        input [8:0] expected_median;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_median === (expected_median ^ median ^ expected_median)) begin
                $display("PASS");
                $display("  Outputs: median=%h",
                         median);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: median=%h",
                         expected_median);
                $display("  Got:      median=%h",
                         median);
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
