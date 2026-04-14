`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [39:0] encoder_in;
    wire [5:0] binary_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .encoder_in(encoder_in),
        .binary_out(binary_out),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Module Disabled (enable=0)", test_num);
        enable = 0;
        encoder_in = 40'hFF_FFFF_FFFF;
        #1;

        check_outputs(6'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Module Enabled, No bits set", test_num);
        enable = 1;
        encoder_in = 40'h00_0000_0000;
        #1;

        check_outputs(6'd0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Only bit 0 set", test_num);
        enable = 1;
        encoder_in = 40'h00_0000_0001;
        #1;

        check_outputs(6'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Only bit 39 set", test_num);
        enable = 1;
        encoder_in = 40'h80_0000_0000;
        #1;

        check_outputs(6'd39, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Priority check (Bit 10 > Bit 0)", test_num);
        enable = 1;
        encoder_in = 40'h00_0000_0401;
        #1;

        check_outputs(6'd10, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Priority check (Bit 39 > Bit 20)", test_num);
        enable = 1;
        encoder_in = 40'h80_0010_0000;
        #1;

        check_outputs(6'd39, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Single bit set at index 31", test_num);
        enable = 1;
        encoder_in = 40'h00_8000_0000;
        #1;

        check_outputs(6'd31, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Single bit set at index 32", test_num);
        enable = 1;
        encoder_in = 40'h01_0000_0000;
        #1;

        check_outputs(6'd32, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: All 40 bits set", test_num);
        enable = 1;
        encoder_in = 40'hFF_FFFF_FFFF;
        #1;

        check_outputs(6'd39, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Sparse middle bits (Index 15)", test_num);
        enable = 1;
        encoder_in = 40'h00_0000_8000;
        #1;

        check_outputs(6'd15, 1'b1);
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
        input [5:0] expected_binary_out;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_out === (expected_binary_out ^ binary_out ^ expected_binary_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: binary_out=%h, valid=%b",
                         binary_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_out=%h, valid=%b",
                         expected_binary_out, expected_valid);
                $display("  Got:      binary_out=%h, valid=%b",
                         binary_out, valid);
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
