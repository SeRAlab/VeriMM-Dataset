`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [15:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .data_in(data_in),
        .crc_out(crc_out)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: All Zeros");
            test_num = test_num + 1;
            data_in = 16'h0000;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: All Ones");
            test_num = test_num + 1;
            data_in = 16'hFFFF;

            #1;


            check_outputs(16'h1D0F);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Single Bit (MSB)");
            test_num = test_num + 1;
            data_in = 16'h8000;

            #1;


            check_outputs(16'h1021);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Alternating Bits (AAAA)");
            test_num = test_num + 1;
            data_in = 16'hAAAA;
            #1;

            check_outputs(16'hEAA8);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Alternating Bits (5555)");
            test_num = test_num + 1;
            data_in = 16'h5555;
            #1;

            check_outputs(16'hF559);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Random Hex Pattern");
            test_num = test_num + 1;
            data_in = 16'h1234;
            #1;

            check_outputs(16'h11B1);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Walking Bit");
            test_num = test_num + 1;
            data_in = 16'h0001;
            #1;

            check_outputs(16'h8408);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [15:0] expected_crc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
