`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data_in;
    wire enable_out;
    wire [5:0] encode_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .enable_out(enable_out),
        .encode_out(encode_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 64'h0;
        #1;

        check_outputs(1'b0, 6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 64'h1;
        #1;

        check_outputs(1'b1, 6'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 64'h8000000000000000;
        #1;

        check_outputs(1'b1, 6'd63);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 64'h0000000100000000;
        #1;

        check_outputs(1'b1, 6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 64'h0000000000000081;
        #1;

        check_outputs(1'b1, 6'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 64'hC000000000000400;
        #1;

        check_outputs(1'b1, 6'd63);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = (64'b1 << 15);
        #1;

        check_outputs(1'b1, 6'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(1'b1, 6'd63);
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
        input expected_enable_out;
        input [5:0] expected_encode_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_enable_out === (expected_enable_out ^ enable_out ^ expected_enable_out) &&
                expected_encode_out === (expected_encode_out ^ encode_out ^ expected_encode_out)) begin
                $display("PASS");
                $display("  Outputs: enable_out=%b, encode_out=%h",
                         enable_out, encode_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enable_out=%b, encode_out=%h",
                         expected_enable_out, expected_encode_out);
                $display("  Got:      enable_out=%b, encode_out=%h",
                         enable_out, encode_out);
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
