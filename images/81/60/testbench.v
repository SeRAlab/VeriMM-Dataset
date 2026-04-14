`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    reg [127:0] key;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .key(key),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 128'h0;
        key = 128'h0;
        $display("Test %0d: All Zeros", test_num);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        key = 128'h0;
        $display("Test %0d: Key is Zero", test_num);
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 128'h0;
        key = 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
        $display("Test %0d: Data is Zero", test_num);
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        key     = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5;
        $display("Test %0d: Identity XOR", test_num);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
        key     = 128'h55555555555555555555555555555555;
        $display("Test %0d: Alternating Bits", test_num);
        #1;

        check_outputs(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 128'h0;
        key     = 128'h1;
        $display("Test %0d: LSB Toggle", test_num);
        #1;

        check_outputs(128'h1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 128'h80000000000000000000000000000000;
        key     = 128'h80000000000000000000000000000000;
        $display("Test %0d: MSB Toggle", test_num);
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 128'h123456789ABCDEF00fedcba987654321;
        key     = 128'hFEDCBA9876543210F0123456789ABCDE;
        $display("Test %0d: Complex Hex Pattern", test_num);

        #1;


        check_outputs(128'hECCECCECCECCECCEFFFFFFFFFFFFFFFF);
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
        input [127:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
