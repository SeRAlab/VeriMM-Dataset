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
            test_num = 1;
            $display("Test Case 001: Basic run (5 identical samples)");

            rst_n = 0; audio_sample = 0;
            @(posedge clk); #1; rst_n = 1;


            audio_sample = 16'hAAAA;
            repeat(5) @(posedge clk);


            audio_sample = 16'hBBBB;
            @(posedge clk);


            #1;



            check_outputs(16'd5);
            @(posedge clk);
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single sample run");
            rst_n = 0; audio_sample = 0;
            @(posedge clk); #1; rst_n = 1;

            audio_sample = 16'h1234;
            @(posedge clk);
            audio_sample = 16'h5678;
            @(posedge clk);

            #1;


            check_outputs(16'd1);
            @(posedge clk);
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Max counter limit (255)");
            rst_n = 0; audio_sample = 0;
            @(posedge clk); #1; rst_n = 1;

            audio_sample = 16'hCCCC;
            repeat(255) @(posedge clk);



            audio_sample = 16'hDDDD;
            @(posedge clk);

            #1;


            check_outputs(16'd255);
            @(posedge clk);
            #1;

            check_outputs(16'hCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Counter overflow (260 samples)");
            rst_n = 0; audio_sample = 0;
            @(posedge clk); #1; rst_n = 1;

            audio_sample = 16'hEEEE;

            repeat(260) @(posedge clk);

            audio_sample = 16'hFFFF;
            @(posedge clk);





            $display("Checking Overflow Split...");


            #1;



            check_outputs(16'd255); @(posedge clk);
            #1;

            check_outputs(16'hEEEE); @(posedge clk);
            #1;

            check_outputs(16'd5); @(posedge clk);
            #1;

            check_outputs(16'hEEEE);
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
