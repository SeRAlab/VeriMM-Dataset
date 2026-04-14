`timescale 1ns/1ps

module audio_codec_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_sample;
    reg clk;
    reg enable;
    reg reset;
    wire [15:0] encoded_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_codec_controller dut (
        .audio_sample(audio_sample),
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .encoded_output(encoded_output)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            audio_sample = 16'h0000;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify reset state", test_num);
            reset_dut();

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic encoding (0x0001 -> 0x0002)", test_num);
            reset_dut();
            audio_sample = 16'h0001;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB overflow (0x8000 -> 0x0000)", test_num);
            reset_dut();
            audio_sample = 16'h8000;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex value encoding (0x1234 -> 0x2468)", test_num);
            reset_dut();
            audio_sample = 16'h1234;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2468);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify encoding disabled (enable=0)", test_num);
            reset_dut();
            audio_sample = 16'hFFFF;
            enable = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value (0xFFFF -> 0xFFFE)", test_num);
            reset_dut();
            audio_sample = 16'hFFFF;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential samples check", test_num);
            reset_dut();


            audio_sample = 16'h0005;
            enable = 1;
            @(posedge clk);


            audio_sample = 16'h000A;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0014);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_codec_controller Testbench");
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
        input [15:0] expected_encoded_output;
        begin
            if (expected_encoded_output === (expected_encoded_output ^ encoded_output ^ expected_encoded_output)) begin
                $display("PASS");
                $display("  Outputs: encoded_output=%h",
                         encoded_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_output=%h",
                         expected_encoded_output);
                $display("  Got:      encoded_output=%h",
                         encoded_output);
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
        $dumpvars(0,audio_sample, clk, enable, reset, encoded_output);
    end

endmodule
