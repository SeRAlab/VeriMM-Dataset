`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [7:0] compression_ratio;
    reg rst;
    reg [15:0] threshold;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .compression_ratio(compression_ratio),
        .rst(rst),
        .threshold(threshold),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in = 0;
            compression_ratio = 1;
            threshold = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Input below threshold", test_num);



            threshold = 16'd2000;
            compression_ratio = 8'd2;
            audio_in = 16'd1000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Positive signal compression", test_num);





            threshold = 16'd4000;
            compression_ratio = 8'd2;
            audio_in = 16'd10000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd7000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Negative signal compression", test_num);







            threshold = 16'd2000;
            compression_ratio = 8'd3;
            audio_in = -16'd5000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'd3000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Compression ratio 1", test_num);



            threshold = 16'd5000;
            compression_ratio = 8'd1;
            audio_in = 16'd15000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd15000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Input at threshold boundary", test_num);



            threshold = 16'd3000;
            compression_ratio = 8'd4;
            audio_in = 16'd3000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd3000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: High compression ratio", test_num);




            threshold = 16'd10000;
            compression_ratio = 8'd10;
            audio_in = 16'd30000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd12000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Max negative input compression", test_num);





            threshold = 16'd10000;
            compression_ratio = 8'd5;
            audio_in = -16'd30000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'd14000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Zero input signal", test_num);

            threshold = 16'd1000;
            compression_ratio = 8'd2;
            audio_in = 16'd0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,audio_in, clk, compression_ratio, rst, threshold, audio_out);
    end

endmodule
