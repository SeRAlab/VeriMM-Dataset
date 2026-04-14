`timescale 1ns/1ps

module audio_sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg reset;
    reg [1:0] scale_factor;
    wire [15:0] audio_out;
    wire audio_out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_sample_rate_converter dut (
        .audio_in(audio_in),
        .clk(clk),
        .reset(reset),
        .scale_factor(scale_factor),
        .audio_out(audio_out),
        .audio_out_valid(audio_out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_in = 0;
            scale_factor = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Scale Factor 1x (1:1 Pass-through)", test_num);
            reset_dut();

            scale_factor = 2'b00;
            audio_in = 16'hA5A5;


            repeat(5) @(posedge clk);


            #1;



            check_outputs(16'hA5A5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Scale Factor 2x", test_num);
            reset_dut();

            scale_factor = 2'b01;
            audio_in = 16'h1234;

            repeat(5) @(posedge clk);



            #1;




            check_outputs(16'h1234, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Scale Factor 4x", test_num);
            reset_dut();

            scale_factor = 2'b10;
            audio_in = 16'hFFFF;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input passthrough", test_num);
            reset_dut();

            scale_factor = 2'b00;
            audio_in = 16'h0000;

            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High-bit data with 2x scale", test_num);
            reset_dut();

            scale_factor = 2'b01;
            audio_in = 16'h8000;

            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h8000, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset State Output", test_num);
            reset_dut();

            audio_in = 16'hDEAD;
            reset = 1;

            repeat(2) @(posedge clk);


            #1;



            check_outputs(16'h0000, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_sample_rate_converter Testbench");
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
        input [15:0] expected_audio_out;
        input expected_audio_out_valid;
        begin
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out) &&
                expected_audio_out_valid === (expected_audio_out_valid ^ audio_out_valid ^ expected_audio_out_valid)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h, audio_out_valid=%b",
                         audio_out, audio_out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h, audio_out_valid=%b",
                         expected_audio_out, expected_audio_out_valid);
                $display("  Got:      audio_out=%h, audio_out_valid=%b",
                         audio_out, audio_out_valid);
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
        $dumpvars(0,audio_in, clk, reset, scale_factor, audio_out, audio_out_valid);
    end

endmodule
