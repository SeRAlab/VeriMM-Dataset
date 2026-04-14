`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_sample;
    wire [15:0] compressed_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_sample(audio_sample),
        .compressed_sample(compressed_sample)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros input", test_num);
            audio_sample = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones input", test_num);
            audio_sample = 16'hFFFF;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only MSB set", test_num);
            audio_sample = 16'h8000;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only lower 8 bits set", test_num);
            audio_sample = 16'h00FF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed value 0xABCD", test_num);
            audio_sample = 16'hABCD;
            #1;

            check_outputs(16'hAB00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits 0x5A5A", test_num);
            audio_sample = 16'h5A5A;
            #1;

            check_outputs(16'h5A00);
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
        input [15:0] expected_compressed_sample;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_sample === (expected_compressed_sample ^ compressed_sample ^ expected_compressed_sample)) begin
                $display("PASS");
                $display("  Outputs: compressed_sample=%h",
                         compressed_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_sample=%h",
                         expected_compressed_sample);
                $display("  Got:      compressed_sample=%h",
                         compressed_sample);
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
