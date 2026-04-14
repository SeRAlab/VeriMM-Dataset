`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] bin;
    wire [15:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = 1;
        bin = 14'd0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        bin = 14'd9;
        #1;

        check_outputs(16'h0009);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        bin = 14'd10;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        bin = 14'd45;
        #1;

        check_outputs(16'h0045);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        bin = 14'd100;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        bin = 14'd512;
        #1;

        check_outputs(16'h0512);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        bin = 14'd1000;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        bin = 14'd1024;
        #1;

        check_outputs(16'h1024);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        bin = 14'd4095;
        #1;

        check_outputs(16'h4095);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        bin = 14'd8192;
        #1;

        check_outputs(16'h8192);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        bin = 14'd9999;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        bin = 14'd1234;
        #1;

        check_outputs(16'h1234);
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
        testcase012();
        
        
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
        input [15:0] expected_bcd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
