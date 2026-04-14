`timescale 1ns/1ps

module ip_checksum_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg valid;
    wire [15:0] checksum_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ip_checksum dut (
        .data_in(data_in),
        .valid(valid),
        .checksum_out(checksum_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Data Input 16'h0000");
            data_in = 16'h0000;
            valid = 1;
            #1;

            check_outputs(16'hFFFF);
            valid = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Data Input 16'hFFFF");
            data_in = 16'hFFFF;
            valid = 1;
            #1;

            check_outputs(16'h0000);
            valid = 0;
            #10;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Data Input 16'h1234");
            data_in = 16'h1234;
            valid = 1;
            #1;

            check_outputs(16'hEDCB);
            valid = 0;
            #10;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Data Input 16'hABCD");
            data_in = 16'hABCD;
            valid = 1;
            #1;

            check_outputs(16'h5432);
            valid = 0;
            #10;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Data Input 16'hF0F0");
            data_in = 16'hF0F0;
            valid = 1;
            #1;

            check_outputs(16'h0F0F);
            valid = 0;
            #10;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ip_checksum Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [15:0] expected_checksum_out;
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
