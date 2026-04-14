`timescale 1ns/1ps

module echo_canceler_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in;
    reg [15:0] echo_ref;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_canceler dut (
        .audio_in(audio_in),
        .echo_ref(echo_ref),
        .audio_out(audio_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Positive Subtraction", test_num);
        audio_in = 16'd1000;
        echo_ref = 16'd300;
        #1;

        check_outputs(16'd700);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Perfect Cancellation (Input equals Echo)", test_num);
        audio_in = 16'hABCD;
        echo_ref = 16'hABCD;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: No Echo (Reference is Zero)", test_num);
        audio_in = 16'h1234;
        echo_ref = 16'h0000;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative Result / Underflow Wrap", test_num);
        audio_in = 16'd100;
        echo_ref = 16'd150;

        #1;


        check_outputs(16'hFFCE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values Subtraction", test_num);
        audio_in = 16'hFFFF;
        echo_ref = 16'h0001;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed Positive Peak to Negative Peak Transition", test_num);
        audio_in = 16'h7FFF;
        echo_ref = 16'hFFFF;

        #1;


        check_outputs(16'h8000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small Values with Non-Zero Reference", test_num);
        audio_in = 16'h0005;
        echo_ref = 16'h0002;
        #1;

        check_outputs(16'h0003);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_canceler Testbench");
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
