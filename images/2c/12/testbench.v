`timescale 1ns/1ps

module noise_suppression_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] signal_in;
    wire clean_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    noise_suppression dut (
        .signal_in(signal_in),
        .clean_signal(clean_signal)
    );
    task testcase001;

    begin
        test_num = 1;
        signal_in = 5'b00000;
        $display("Test %0d: All zeros input", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        signal_in = 5'b11111;
        $display("Test %0d: All ones input", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        signal_in = 5'b00111;
        $display("Test %0d: Majority ones (3/5)", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        signal_in = 5'b11000;
        $display("Test %0d: Majority zeros (2/5)", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        signal_in = 5'b10101;
        $display("Test %0d: Interleaved majority ones", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        signal_in = 5'b01010;
        $display("Test %0d: Interleaved majority zeros", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        signal_in = 5'b11110;
        $display("Test %0d: Single zero noise suppression", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        signal_in = 5'b00001;
        $display("Test %0d: Single one noise suppression", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        signal_in = 5'b11011;
        $display("Test %0d: Majority ones variant", test_num);
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        signal_in = 5'b00100;
        $display("Test %0d: Majority zeros variant", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("noise_suppression Testbench");
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
        input expected_clean_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_clean_signal === (expected_clean_signal ^ clean_signal ^ expected_clean_signal)) begin
                $display("PASS");
                $display("  Outputs: clean_signal=%b",
                         clean_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clean_signal=%b",
                         expected_clean_signal);
                $display("  Got:      clean_signal=%b",
                         clean_signal);
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
