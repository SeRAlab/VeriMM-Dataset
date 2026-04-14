`timescale 1ns/1ps

module ofdm_demodulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] freq_symbol;
    wire [3:0] demodulated_symbol;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_demodulator dut (
        .freq_symbol(freq_symbol),
        .demodulated_symbol(demodulated_symbol)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b0000", test_num);
        freq_symbol = 4'b0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b1111", test_num);
        freq_symbol = 4'b1111;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b1010", test_num);
        freq_symbol = 4'b1010;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b0101", test_num);
        freq_symbol = 4'b0101;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b0011", test_num);
        freq_symbol = 4'b0011;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b1100", test_num);
        freq_symbol = 4'b1100;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b0001", test_num);
        freq_symbol = 4'b0001;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input 4'b1001", test_num);
        freq_symbol = 4'b1001;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_demodulator Testbench");
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
        input [3:0] expected_demodulated_symbol;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_demodulated_symbol === (expected_demodulated_symbol ^ demodulated_symbol ^ expected_demodulated_symbol)) begin
                $display("PASS");
                $display("  Outputs: demodulated_symbol=%h",
                         demodulated_symbol);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: demodulated_symbol=%h",
                         expected_demodulated_symbol);
                $display("  Got:      demodulated_symbol=%h",
                         demodulated_symbol);
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
