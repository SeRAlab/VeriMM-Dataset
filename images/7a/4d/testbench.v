`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [7:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All Zeros", test_num);
            data_in = 8'b00000000;
            #10;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All Ones", test_num);
            data_in = 8'b11111111;
            #10;
            #1;

            check_outputs(8'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Single Bit Set (LSB)", test_num);
            data_in = 8'b00000001;
            #10;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Single Bit Set (MSB)", test_num);
            data_in = 8'b10000000;
            #10;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Alternating Bits Pattern 1", test_num);
            data_in = 8'b10101010;
            #10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating Bits Pattern 2", test_num);
            data_in = 8'b01010101;
            #10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Nibble Test (Upper)", test_num);
            data_in = 8'b11110000;
            #10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Nibble Test (Lower)", test_num);
            data_in = 8'b00001111;
            #10;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Random Pattern 1", test_num);
            data_in = 8'b11010110;
            #10;
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Random Pattern 2", test_num);
            data_in = 8'b01111110;
            #10;
            #1;

            check_outputs(8'd6);
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
        input [7:0] expected_checksum_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%h",
                         checksum_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%h",
                         expected_checksum_out);
                $display("  Got:      checksum_out=%h",
                         checksum_out);
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
