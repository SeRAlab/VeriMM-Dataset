`timescale 1ns/1ps

module audio_level_controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] audio_in;
    reg [1:0] volume_factor;
    wire [3:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_level_controller dut (
        .audio_in(audio_in),
        .volume_factor(volume_factor),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 00 (Mute) - Input 12", test_num);
        audio_in = 4'd12;
        volume_factor = 2'b00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 01 (Unity) - Input 5", test_num);
        audio_in = 4'd5;
        volume_factor = 2'b01;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 10 (Double) - Input 4", test_num);
        audio_in = 4'd4;
        volume_factor = 2'b10;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 10 (Double) - Input 7", test_num);
        audio_in = 4'd7;
        volume_factor = 2'b10;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 10 (Double) Overflow - Input 9", test_num);
        audio_in = 4'd9;
        volume_factor = 2'b10;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 11 (Cap 15) - Input 1", test_num);
        audio_in = 4'd1;
        volume_factor = 2'b11;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 11 (Cap 15) - Input 15", test_num);
        audio_in = 4'd15;
        volume_factor = 2'b11;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 01 (Unity) - Input 15", test_num);
        audio_in = 4'd15;
        volume_factor = 2'b01;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Factor 00 (Mute) - Input 0", test_num);
        audio_in = 4'd0;
        volume_factor = 2'b00;
        #1;

        check_outputs(4'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_level_controller Testbench");
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
        input [3:0] expected_audio_out;
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
