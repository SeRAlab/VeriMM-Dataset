`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg enable;
    reg [15:0] mask;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .data_in(data_in),
        .enable(enable),
        .mask(mask),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Bypass Mode (enable=0)");
            data_in = 16'hAAAA;
            mask = 16'h5555;
            enable = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Masking All Bits (enable=1, mask=0)");
            data_in = 16'hFFFF;
            mask = 16'h0000;
            enable = 1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Transparent Mask (enable=1, mask=FFFF)");
            data_in = 16'h1234;
            mask = 16'hFFFF;
            enable = 1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Partial Masking (enable=1)");
            data_in = 16'hF0F0;
            mask = 16'hCCCC;
            enable = 1;

            #1;


            check_outputs(16'hC0C0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Random Logic Check (enable=1)");
            data_in = 16'hBEEF;
            mask = 16'hDEAD;
            enable = 1;

            #1;


            check_outputs(16'h9EAD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reverting to Bypass (enable=0)");
            data_in = 16'h1234;
            mask = 16'h0000;
            enable = 1;
            #1;
            enable = 0;
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
        $display("bitwise_and Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [15:0] expected_data_out;
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
