`timescale 1ns/1ps

module audio_compression_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_sample;
    reg clk;
    reg reset;
    reg valid_sample;
    wire [15:0] compressed_output;
    wire valid_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compression dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .reset(reset),
        .valid_sample(valid_sample),
        .compressed_output(compressed_output),
        .valid_output(valid_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_sample = 16'h0000;
            valid_sample = 0;
            repeat (2) @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Typical sample input (0x1234)", test_num);
            reset_dut();

            audio_sample = 16'h1234;
            valid_sample = 1;
            @(posedge clk);
            valid_sample = 0;



            repeat (5) begin
                if (valid_output) break;
                @(posedge clk);
            end



            #1;




            check_outputs(compressed_output, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Silence input (0x0000)", test_num);
            reset_dut();

            audio_sample = 16'h0000;
            valid_sample = 1;
            @(posedge clk);
            valid_sample = 0;

            repeat (5) begin
                if (valid_output) break;
                @(posedge clk);
            end

            #1;


            check_outputs(compressed_output, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum amplitude input (0xFFFF)", test_num);
            reset_dut();

            audio_sample = 16'hFFFF;
            valid_sample = 1;
            @(posedge clk);
            valid_sample = 0;

            repeat (5) begin
                if (valid_output) break;
                @(posedge clk);
            end

            #1;


            check_outputs(compressed_output, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Processing sequence of samples", test_num);
            reset_dut();


            audio_sample = 16'hAAAA;
            valid_sample = 1;
            @(posedge clk);


            audio_sample = 16'h5555;
            valid_sample = 1;
            @(posedge clk);
            valid_sample = 0;


            repeat (10) begin
                @(posedge clk);
            end


            #1;



            check_outputs(compressed_output, valid_output);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compression Testbench");
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
        input [15:0] expected_compressed_output;
        input expected_valid_output;
        begin
            if (expected_compressed_output === (expected_compressed_output ^ compressed_output ^ expected_compressed_output) &&
                expected_valid_output === (expected_valid_output ^ valid_output ^ expected_valid_output)) begin
                $display("PASS");
                $display("  Outputs: compressed_output=%h, valid_output=%b",
                         compressed_output, valid_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_output=%h, valid_output=%b",
                         expected_compressed_output, expected_valid_output);
                $display("  Got:      compressed_output=%h, valid_output=%b",
                         compressed_output, valid_output);
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
        $dumpvars(0,audio_sample, clk, reset, valid_sample, compressed_output, valid_output);
    end

endmodule
