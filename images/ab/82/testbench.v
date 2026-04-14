`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] control;
    reg [31:0] first;
    reg [31:0] second;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .first(first),
        .second(second),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Addition (10 + 20)", test_num);
        control = 4'h0;
        first = 32'd10;
        second = 32'd20;
        #1;

        check_outputs(32'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Subtraction (50 - 15)", test_num);
        control = 4'h1;
        first = 32'd50;
        second = 32'd15;
        #1;

        check_outputs(32'd35);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Bitwise AND", test_num);
        control = 4'h2;
        first = 32'hFFFF0000;
        second = 32'hAAAA_AAAA;
        #1;

        check_outputs(32'hAAAA0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Bitwise OR", test_num);
        control = 4'h3;
        first = 32'hF0F0F0F0;
        second = 32'h0F0F0F0F;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Bitwise NOR", test_num);
        control = 4'h4;
        first = 32'h00000000;
        second = 32'h0000FFFF;
        #1;

        check_outputs(32'hFFFF0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bitwise XOR", test_num);
        control = 4'h5;
        first = 32'h12345678;
        second = 32'h12345678;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Left Shift Logical (1 << 4)", test_num);
        control = 4'h6;
        first = 32'h00000001;
        second = 32'd4;
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Arithmetic Right Shift (Negative value)", test_num);
        control = 4'h7;
        first = 32'h80000000;
        second = 32'd2;
        #1;

        check_outputs(32'hE0000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Logical Right Shift (Negative value)", test_num);
        control = 4'h8;
        first = 32'h80000000;
        second = 32'd2;
        #1;

        check_outputs(32'h20000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Invalid Control Signal", test_num);
        control = 4'hF;
        first = 32'hFFFFFFFF;
        second = 32'hFFFFFFFF;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Addition (Result fits in 32-bit signed)", test_num);
        control = 4'h0;
        first = 32'd5;
        second = -32'd10;
        #1;

        check_outputs(32'hFFFFFFF6);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
