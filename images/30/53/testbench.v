`timescale 1ns/1ps

module phase_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] phase_shift;
    reg [4:0] signal_in;
    wire [4:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    phase_shifter dut (
        .phase_shift(phase_shift),
        .signal_in(signal_in),
        .signal_out(signal_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No shift", test_num);
            signal_in = 5'b10101;
            phase_shift = 3'd0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 1 (bit 4 wraps to 0)", test_num);
            signal_in = 5'b10001;
            phase_shift = 3'd1;
            #1;

            check_outputs(5'b00011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 2", test_num);
            signal_in = 5'b10011;
            phase_shift = 3'd2;
            #1;

            check_outputs(5'b01110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 3", test_num);
            signal_in = 5'b11000;
            phase_shift = 3'd3;
            #1;

            check_outputs(5'b00110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 4", test_num);
            signal_in = 5'b00111;
            phase_shift = 3'd4;
            #1;

            check_outputs(5'b10011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 5 (identity)", test_num);
            signal_in = 5'b10110;
            phase_shift = 3'd5;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Shift left by 7 (equivalent to shift by 2)", test_num);
            signal_in = 5'b10101;
            phase_shift = 3'd7;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero input shift", test_num);
            signal_in = 5'b00000;
            phase_shift = 3'd3;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All ones input shift", test_num);
            signal_in = 5'b11111;
            phase_shift = 3'd2;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Wrapping MSB to LSB", test_num);
            signal_in = 5'b10000;
            phase_shift = 3'd1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("phase_shifter Testbench");
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
        input [4:0] expected_signal_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%h",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%h",
                         expected_signal_out);
                $display("  Got:      signal_out=%h",
                         signal_out);
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
