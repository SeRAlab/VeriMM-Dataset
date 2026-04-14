`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [11:0] codeword;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .codeword(codeword)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        data_in = 8'h00;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: All Ones", test_num);
        data_in = 8'hFF;
        #1;

        check_outputs(12'hF77);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Data 0x01", test_num);
        data_in = 8'h01;
        #1;

        check_outputs(12'h007);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Data 0x02", test_num);
        data_in = 8'h02;
        #1;

        check_outputs(12'h019);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Data 0x04", test_num);
        data_in = 8'h04;
        #1;

        check_outputs(12'h02A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Data 0x08", test_num);
        data_in = 8'h08;
        #1;

        check_outputs(12'h04B);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Data 0x80", test_num);
        data_in = 8'h80;
        #1;

        check_outputs(12'h888);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Alternating 0xAA", test_num);
        data_in = 8'hAA;
        #1;

        check_outputs(12'hA58);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Alternating 0x55", test_num);
        data_in = 8'h55;
        #1;

        check_outputs(12'h52F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Data 0x7B", test_num);
        data_in = 8'h7B;
        #1;

        check_outputs(12'h7D5);
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
        input [11:0] expected_codeword;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_codeword === (expected_codeword ^ codeword ^ expected_codeword)) begin
                $display("PASS");
                $display("  Outputs: codeword=%h",
                         codeword);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: codeword=%h",
                         expected_codeword);
                $display("  Got:      codeword=%h",
                         codeword);
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
