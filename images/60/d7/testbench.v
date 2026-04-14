`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] h;
    wire [3:0] count_ones;
    wire [11:0] mirror_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .h(h),
        .count_ones(count_ones),
        .mirror_bits(mirror_bits)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All zeros", test_num);
        h = 12'b000000000000;
        #1;

        check_outputs(4'd0, 12'b000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All ones", test_num);
        h = 12'b111111111111;
        #1;

        check_outputs(4'd12, 12'b111111111111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern A (0xAAA)", test_num);
        h = 12'hAAA;
        #1;

        check_outputs(4'd6, 12'h555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating pattern B (0x555)", test_num);
        h = 12'h555;
        #1;

        check_outputs(4'd6, 12'hAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Specification example", test_num);
        h = 12'b110010101011;
        #1;

        check_outputs(4'd7, 12'b110101010011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit MSB", test_num);
        h = 12'b100000000000;
        #1;

        check_outputs(4'd1, 12'b000000000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single bit LSB", test_num);
        h = 12'b000000000001;
        #1;

        check_outputs(4'd1, 12'b100000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Block pattern (0xF0C)", test_num);
        h = 12'b111100001100;
        #1;

        check_outputs(4'd6, 12'b001100001111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Symmetric pattern (0x9F9)", test_num);
        h = 12'b100111111001;
        #1;

        check_outputs(4'd8, 12'b100111111001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random distribution (0x6DB)", test_num);
        h = 12'b011011011011;
        #1;

        check_outputs(4'd8, 12'b110110110110);
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
        input [3:0] expected_count_ones;
        input [11:0] expected_mirror_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_count_ones === (expected_count_ones ^ count_ones ^ expected_count_ones) &&
                expected_mirror_bits === (expected_mirror_bits ^ mirror_bits ^ expected_mirror_bits)) begin
                $display("PASS");
                $display("  Outputs: count_ones=%h, mirror_bits=%h",
                         count_ones, mirror_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_ones=%h, mirror_bits=%h",
                         expected_count_ones, expected_mirror_bits);
                $display("  Got:      count_ones=%h, mirror_bits=%h",
                         count_ones, mirror_bits);
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
