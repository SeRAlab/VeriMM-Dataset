`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data;
    wire [11:0] code;

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
        test_num = 1;
        data = 8'h00;
        $display("Test Case 001: Data=0x00");
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data = 8'h01;
        $display("Test Case 002: Data=0x01");

        #1;


        check_outputs(12'h007);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data = 8'h02;
        $display("Test Case 003: Data=0x02");

        #1;


        check_outputs(12'h019);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data = 8'h04;
        $display("Test Case 004: Data=0x04");

        #1;


        check_outputs(12'h02A);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data = 8'h08;
        $display("Test Case 005: Data=0x08");

        #1;


        check_outputs(12'h04B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data = 8'h10;
        $display("Test Case 006: Data=0x10");

        #1;


        check_outputs(12'h181);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data = 8'h80;
        $display("Test Case 007: Data=0x80");

        #1;


        check_outputs(12'h888);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data = 8'h55;
        $display("Test Case 008: Data=0x55");
        #1;

        check_outputs(12'h52F);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data = 8'hAA;
        $display("Test Case 009: Data=0xAA");
        #1;

        check_outputs(12'hA58);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data = 8'hFF;
        $display("Test Case 010: Data=0xFF");
        #1;

        check_outputs(12'hF77);
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
        input [11:0] expected_code;
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
