`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] log2N;
    wire [31:0] N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .log2N(log2N),
        .N(N)
    );
    task testcase001;

    begin
        test_num = 1;
        log2N = 8'd0;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        log2N = 8'd1;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        log2N = 8'd4;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        log2N = 8'd8;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00000100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        log2N = 8'd10;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00000400);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        log2N = 8'd16;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        log2N = 8'd24;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h01000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        log2N = 8'd31;
        $display("Testcase %03d: log2N = %d", test_num, log2N);
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        log2N = 8'd32;
        $display("Testcase %03d: log2N = %d (Overflow)", test_num, log2N);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        log2N = 8'd255;
        $display("Testcase %03d: log2N = %d (Large Overflow)", test_num, log2N);
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_N;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_N === (expected_N ^ N ^ expected_N)) begin
                $display("PASS");
                $display("  Outputs: N=%h",
                         N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: N=%h",
                         expected_N);
                $display("  Got:      N=%h",
                         N);
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
