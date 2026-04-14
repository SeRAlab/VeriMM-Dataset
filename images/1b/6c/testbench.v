`timescale 1ns/1ps

module checksum_generator_checker_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    reg [7:0] given_checksum;
    wire [7:0] checksum;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    checksum_generator_checker dut (
        .data(data),
        .given_checksum(given_checksum),
        .checksum(checksum),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Minimal Input (0x00)", test_num);
            data = 8'h00;
            given_checksum = 8'h00;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Maximal Input (0xFF)", test_num);
            data = 8'hFF;
            given_checksum = 8'hFF;
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Alternating Bits 0101 (0x55)", test_num);
            data = 8'h55;
            given_checksum = 8'h55;
            #1;

            check_outputs(8'h55, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Alternating Bits 1010 (0xAA)", test_num);
            data = 8'hAA;
            given_checksum = 8'hAA;
            #1;

            check_outputs(8'hAA, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Mismatched Checksum (Failure Case)", test_num);
            data = 8'hA5;
            given_checksum = 8'h5A;
            #1;

            check_outputs(8'hA5, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Mismatched Checksum (Zero Data)", test_num);
            data = 8'h00;
            given_checksum = 8'h01;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Arbitrary Value (0x12)", test_num);
            data = 8'h12;
            given_checksum = 8'h12;
            #1;

            check_outputs(8'h12, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Off-by-one Checksum (Failure Case)", test_num);
            data = 8'h7F;
            given_checksum = 8'h7E;
            #1;

            check_outputs(8'h7F, 1'b0);
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
        input [7:0] expected_checksum;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, valid=%b",
                         checksum, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, valid=%b",
                         expected_checksum, expected_valid);
                $display("  Got:      checksum=%h, valid=%b",
                         checksum, valid);
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
