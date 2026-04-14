`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in;
    reg [7:0] compression_ratio;
    reg [15:0] threshold;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .compression_ratio(compression_ratio),
        .threshold(threshold),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input below threshold", test_num);
            audio_in = 16'd5000;
            threshold = 16'd10000;
            compression_ratio = 8'd2;
            #1;

            check_outputs(16'd5000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input at threshold", test_num);
            audio_in = 16'd10000;
            threshold = 16'd10000;
            compression_ratio = 8'd4;
            #1;

            check_outputs(16'd10000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input above threshold (Ratio 2)", test_num);
            audio_in = 16'd20000;
            threshold = 16'd10000;
            compression_ratio = 8'd2;
            #1;

            check_outputs(16'd15000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input above threshold (Ratio 4)", test_num);
            audio_in = 16'd30000;
            threshold = 16'd10000;
            compression_ratio = 8'd4;
            #1;

            check_outputs(16'd15000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Compression ratio 1 (No compression)", test_num);
            audio_in = 16'd40000;
            threshold = 16'd10000;
            compression_ratio = 8'd1;
            #1;

            check_outputs(16'd40000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Zero threshold compression", test_num);
            audio_in = 16'd32000;
            threshold = 16'd0;
            compression_ratio = 8'd8;
            #1;

            check_outputs(16'd4000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High input, high compression ratio", test_num);
            audio_in = 16'hFFFF;
            threshold = 16'd5000;
            compression_ratio = 8'd10;
            #1;

            check_outputs(16'd11053);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Smallest delta above threshold", test_num);
            audio_in = 16'd1001;
            threshold = 16'd1000;
            compression_ratio = 8'd2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
