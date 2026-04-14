`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in1;
    reg [15:0] audio_in2;
    reg [15:0] audio_in3;
    reg [15:0] audio_in4;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .audio_in3(audio_in3),
        .audio_in4(audio_in4),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero", test_num);
        audio_in1 = 16'h0000;
        audio_in2 = 16'h0000;
        audio_in3 = 16'h0000;
        audio_in4 = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs maximum (0xFFFF)", test_num);
        audio_in1 = 16'hFFFF;
        audio_in2 = 16'hFFFF;
        audio_in3 = 16'hFFFF;
        audio_in4 = 16'hFFFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Balanced mid-range", test_num);
        audio_in1 = 16'h4000;
        audio_in2 = 16'h4000;
        audio_in3 = 16'h4000;
        audio_in4 = 16'h4000;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sum less than 4 (Result should be 0)", test_num);
        audio_in1 = 16'h0001;
        audio_in2 = 16'h0001;
        audio_in3 = 16'h0001;
        audio_in4 = 16'h0000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed large values", test_num);
        audio_in1 = 16'hFFFF;
        audio_in2 = 16'h0000;
        audio_in3 = 16'hFFFF;
        audio_in4 = 16'h0000;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary values check", test_num);
        audio_in1 = 16'h1234;
        audio_in2 = 16'h5678;
        audio_in3 = 16'h9ABC;
        audio_in4 = 16'hDEF0;


        #1;



        check_outputs(16'h740F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single high input", test_num);
        audio_in1 = 16'h8000;
        audio_in2 = 16'h0000;
        audio_in3 = 16'h0000;
        audio_in4 = 16'h0000;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
