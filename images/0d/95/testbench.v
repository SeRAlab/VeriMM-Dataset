`timescale 1ns/1ps

module md5_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [3:0] checksum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    md5_checksum dut (
        .data(data),
        .checksum(checksum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All bits zero (Even parity)");
            data = 4'b0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Single bit set - LSB (Odd parity)");
            data = 4'b0001;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Two bits set (Even parity)");
            data = 4'b0011;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Single bit set - MSB (Odd parity)");
            data = 4'b1000;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Three bits set (Odd parity)");
            data = 4'b0111;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: All bits set (Even parity)");
            data = 4'b1111;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Alternating bits (Even parity)");
            data = 4'b1010;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Alternating bits (Odd parity)");
            data = 4'b1011;
            #1;

            check_outputs(4'h1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("md5_checksum Testbench");
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
        input [3:0] expected_checksum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h",
                         checksum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h",
                         expected_checksum);
                $display("  Got:      checksum=%h",
                         checksum);
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
