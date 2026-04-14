`timescale 1ns/1ps

module ofdm_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] symbol;
    wire [15:0] modulated_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ofdm_modulator dut (
        .symbol(symbol),
        .modulated_signal(modulated_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h0", test_num);
            symbol = 4'h0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'hF", test_num);
            symbol = 4'hF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'hA", test_num);
            symbol = 4'hA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h5", test_num);
            symbol = 4'h5;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h3", test_num);
            symbol = 4'h3;
            #1;

            check_outputs(16'h3333);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'hC", test_num);
            symbol = 4'hC;
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h1", test_num);
            symbol = 4'h1;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h8", test_num);
            symbol = 4'h8;
            #1;

            check_outputs(16'h8888);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h6", test_num);
            symbol = 4'h6;
            #1;

            check_outputs(16'h6666);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Symbol 4'h9", test_num);
            symbol = 4'h9;
            #1;

            check_outputs(16'h9999);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ofdm_modulator Testbench");
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
        input [15:0] expected_modulated_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_modulated_signal === (expected_modulated_signal ^ modulated_signal ^ expected_modulated_signal)) begin
                $display("PASS");
                $display("  Outputs: modulated_signal=%h",
                         modulated_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: modulated_signal=%h",
                         expected_modulated_signal);
                $display("  Got:      modulated_signal=%h",
                         modulated_signal);
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
