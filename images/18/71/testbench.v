`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [6:0] code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data(data),
        .code(code)
    );
    task testcase001;

    begin
        $display("Test Case 001: Data = 4'b0000 (All Zeros)");
        test_num = 1;
        data = 4'b0000;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Data = 4'b0001 (D0 only)");
        test_num = 2;
        data = 4'b0001;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Data = 4'b0010 (D1 only)");
        test_num = 3;
        data = 4'b0010;
        #1;

        check_outputs(7'h19);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Data = 4'b0100 (D2 only)");
        test_num = 4;
        data = 4'b0100;
        #1;

        check_outputs(7'h2A);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Data = 4'b1000 (D3 only)");
        test_num = 5;
        data = 4'b1000;
        #1;

        check_outputs(7'h4B);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Data = 4'b1111 (All Ones)");
        test_num = 6;
        data = 4'b1111;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Data = 4'b1010 (Alternating A)");
        test_num = 7;
        data = 4'b1010;
        #1;

        check_outputs(7'h52);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Data = 4'b0101 (Alternating 5)");
        test_num = 8;
        data = 4'b0101;
        #1;

        check_outputs(7'h2D);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Data = 4'b0111 (Three bits set)");
        test_num = 9;
        data = 4'b0111;
        #1;

        check_outputs(7'h34);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: Data = 4'b1110 (Three bits set)");
        test_num = 10;
        data = 4'b1110;
        #1;

        check_outputs(7'h78);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [6:0] expected_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code === (expected_code ^ code ^ expected_code)) begin
                $display("PASS");
                $display("  Outputs: code=%h",
                         code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code=%h",
                         expected_code);
                $display("  Got:      code=%h",
                         code);
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
