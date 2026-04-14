`timescale 1ns/1ps

module median_filter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    wire [7:0] median;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    median_filter dut (
        .a(a),
        .b(b),
        .c(c),
        .median(median)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Distinct values in ascending order (a < b < c)");
        a = 8'd10; b = 8'd50; c = 8'd100;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Distinct values in descending order (a > b > c)");
        a = 8'd200; b = 8'd150; c = 8'd100;
        #1;

        check_outputs(8'd150);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Median at the 'a' position");
        a = 8'd75; b = 8'd25; c = 8'd125;
        #1;

        check_outputs(8'd75);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Median at the 'c' position");
        a = 8'd10; b = 8'd200; c = 8'd80;
        #1;

        check_outputs(8'd80);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Two values are equal (Smallest)");
        a = 8'd40; b = 8'd40; c = 8'd90;
        #1;

        check_outputs(8'd40);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: Two values are equal (Largest)");
        a = 8'd120; b = 8'd30; c = 8'd120;
        #1;

        check_outputs(8'd120);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case 007: All three values are identical");
        a = 8'd215; b = 8'd215; c = 8'd215;
        #1;

        check_outputs(8'd215);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case 008: Including zero boundary");
        a = 8'd0; b = 8'd255; c = 8'd127;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case 009: Including maximum 8-bit value");
        a = 8'hFF; b = 8'hFE; c = 8'h00;
        #1;

        check_outputs(8'hFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case 010: Values close together");
        a = 8'd42; b = 8'd43; c = 8'd41;
        #1;

        check_outputs(8'd42);
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
        input [7:0] expected_median;
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
