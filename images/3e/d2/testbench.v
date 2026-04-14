`timescale 1ns/1ps

module checksum_generator_checker_tb;

    // Testbench signals (combinational circuit)
    reg data_checksum;
    reg [7:0] data_in;
    wire checksum_out;
    wire is_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator_checker dut (
        .data_checksum(data_checksum),
        .data_in(data_in),
        .checksum_out(checksum_out),
        .is_valid(is_valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros - Even parity", test_num);
            data_in = 8'b0000_0000;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set - Odd parity", test_num);
            data_in = 8'b0000_0001;
            data_checksum = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit set - Invalid received checksum", test_num);
            data_in = 8'b0000_1000;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits set - Even parity (8 bits)", test_num);
            data_in = 8'b1111_1111;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits set - Invalid received checksum", test_num);
            data_in = 8'b1111_1111;
            data_checksum = 1'b1;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Seven bits set - Odd parity", test_num);
            data_in = 8'b0111_1111;
            data_checksum = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0xAA) - Even parity", test_num);
            data_in = 8'hAA;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0x55) - Even parity", test_num);
            data_in = 8'h55;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern - Odd parity", test_num);
            data_in = 8'b1101_1010;
            data_checksum = 1'b1;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern - Invalid received checksum", test_num);
            data_in = 8'b1101_1010;
            data_checksum = 1'b0;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("checksum_generator_checker Testbench");
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
        input expected_checksum_out;
        input expected_is_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum_out === (expected_checksum_out ^ checksum_out ^ expected_checksum_out) &&
                expected_is_valid === (expected_is_valid ^ is_valid ^ expected_is_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum_out=%b, is_valid=%b",
                         checksum_out, is_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum_out=%b, is_valid=%b",
                         expected_checksum_out, expected_is_valid);
                $display("  Got:      checksum_out=%b, is_valid=%b",
                         checksum_out, is_valid);
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
