`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary;
    wire [31:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .bcd_out(bcd_out)
    );
    task testcase001;

        begin
            test_num = 1;
            binary = 8'd0;
            $display("Test Case %0d: Input Binary = 0 (Special Condition: Output BCD 1)", test_num);
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            binary = 8'd1;
            $display("Test Case %0d: Input Binary = 1", test_num);
            #1;

            check_outputs(32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            binary = 8'd9;
            $display("Test Case %0d: Input Binary = 9", test_num);
            #1;

            check_outputs(32'h0000_0009);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            binary = 8'd10;
            $display("Test Case %0d: Input Binary = 10", test_num);
            #1;

            check_outputs(32'h0000_0010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            binary = 8'd45;
            $display("Test Case %0d: Input Binary = 45", test_num);
            #1;

            check_outputs(32'h0000_0045);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            binary = 8'd99;
            $display("Test Case %0d: Input Binary = 99", test_num);
            #1;

            check_outputs(32'h0000_0099);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            binary = 8'd100;
            $display("Test Case %0d: Input Binary = 100", test_num);
            #1;

            check_outputs(32'h0000_0100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            binary = 8'd123;
            $display("Test Case %0d: Input Binary = 123", test_num);
            #1;

            check_outputs(32'h0000_0123);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            binary = 8'd200;
            $display("Test Case %0d: Input Binary = 200", test_num);
            #1;

            check_outputs(32'h0000_0200);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            binary = 8'd255;
            $display("Test Case %0d: Input Binary = 255 (Maximum 8-bit)", test_num);
            #1;

            check_outputs(32'h0000_0255);
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
        input [31:0] expected_bcd_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
