`timescale 1ns/1ps

module audio_gain_control_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in;
    reg [1:0] gain_ctrl;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_gain_control dut (
        .audio_in(audio_in),
        .gain_ctrl(gain_ctrl),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 00 (x1) - Normal Value", test_num);
            audio_in = 16'h1234;
            gain_ctrl = 2'b00;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 01 (x2) - Normal Value", test_num);
            audio_in = 16'h0005;
            gain_ctrl = 2'b01;
            #1;

            check_outputs(16'h000A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 10 (x4) - Normal Value", test_num);
            audio_in = 16'h0010;
            gain_ctrl = 2'b10;
            #1;

            check_outputs(16'h0040);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 11 (x8) - Normal Value", test_num);
            audio_in = 16'h0100;
            gain_ctrl = 2'b11;
            #1;

            check_outputs(16'h0800);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 11 (x8) - Zero Input", test_num);
            audio_in = 16'h0000;
            gain_ctrl = 2'b11;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 01 (x2) - Max Value (Truncation)", test_num);

            audio_in = 16'hFFFF;
            gain_ctrl = 2'b01;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 10 (x4) - Large Value (Truncation)", test_num);

            audio_in = 16'h4000;
            gain_ctrl = 2'b10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Gain 11 (x8) - Signed-like Negative Value", test_num);

            audio_in = 16'hFFF0;
            gain_ctrl = 2'b11;
            #1;

            check_outputs(16'hFF80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_gain_control Testbench");
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
        input [15:0] expected_audio_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h",
                         audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h",
                         expected_audio_out);
                $display("  Got:      audio_out=%h",
                         audio_out);
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
