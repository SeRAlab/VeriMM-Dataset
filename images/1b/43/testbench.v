`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_sample;
    wire [7:0] compressed_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_sample(audio_sample),
        .compressed_output(compressed_output)
    );
    task testcase001;

    begin
        test_num = 1;
        audio_sample = 16'd0;
        $display("Running Testcase %0d: Input 0", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        audio_sample = 16'd128;
        $display("Running Testcase %0d: Input 128 (Threshold boundary)", test_num);
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        audio_sample = 16'd129;
        $display("Running Testcase %0d: Input 129 (129/2 = 64)", test_num);
        #1;

        check_outputs(8'd64);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        audio_sample = 16'd100;
        $display("Running Testcase %0d: Input 100", test_num);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        audio_sample = 16'd400;
        $display("Running Testcase %0d: Input 400 (400/2 = 200)", test_num);
        #1;

        check_outputs(8'd200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        audio_sample = 16'd511;
        $display("Running Testcase %0d: Input 511 (511/2 = 255)", test_num);
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        audio_sample = 16'd512;
        $display("Running Testcase %0d: Input 512 (512/2 = 256, truncates to 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compressor Testbench");
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
        input [7:0] expected_compressed_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_output === (expected_compressed_output ^ compressed_output ^ expected_compressed_output)) begin
                $display("PASS");
                $display("  Outputs: compressed_output=%h",
                         compressed_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_output=%h",
                         expected_compressed_output);
                $display("  Got:      compressed_output=%h",
                         compressed_output);
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
