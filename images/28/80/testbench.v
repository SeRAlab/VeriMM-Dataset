`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [20:0] code_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data_in(data_in),
        .code_out(code_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        data_in = 16'h0000;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones", test_num);
        data_in = 16'hFFFF;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking One (LSB)", test_num);
        data_in = 16'h0001;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Walking One (MSB)", test_num);
        data_in = 16'h8000;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits 0101", test_num);
        data_in = 16'h5555;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits 1010", test_num);
        data_in = 16'hAAAA;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Low Byte Set", test_num);
        data_in = 16'h00FF;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: High Byte Set", test_num);
        data_in = 16'hFF00;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary Hex 1234", test_num);
        data_in = 16'h1234;
        #1;

        check_outputs(calculate_expected(data_in));
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary Hex ABCD", test_num);
        data_in = 16'hABCD;
        #1;

        check_outputs(calculate_expected(data_in));
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
        input [20:0] expected_code_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_code_out === (expected_code_out ^ code_out ^ expected_code_out)) begin
                $display("PASS");
                $display("  Outputs: code_out=%h",
                         code_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: code_out=%h",
                         expected_code_out);
                $display("  Got:      code_out=%h",
                         code_out);
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
