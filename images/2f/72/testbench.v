`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_A;
    reg [15:0] audio_B;
    reg clk;
    reg select;
    wire [15:0] output_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_A(audio_A),
        .audio_B(audio_B),
        .clk(clk),
        .select(select),
        .output_audio(output_audio)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            audio_A <= 16'h0;
            audio_B <= 16'h0;
            select <= 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select Audio A (select=0)", test_num);
            audio_A <= 16'hAAAA;
            audio_B <= 16'h5555;
            select <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select Audio B (select=1)", test_num);
            audio_A <= 16'hAAAA;
            audio_B <= 16'h5555;
            select <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select Audio A (A=FFFF, B=0000)", test_num);
            audio_A <= 16'hFFFF;
            audio_B <= 16'h0000;
            select <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Select Audio B (A=FFFF, B=0000)", test_num);
            audio_A <= 16'hFFFF;
            audio_B <= 16'h0000;
            select <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Switching from A to B", test_num);

            audio_A <= 16'h1234;
            audio_B <= 16'h5678;
            select <= 1'b0;
            @(posedge clk);
            #1;

            select <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h5678);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Change Audio B value while select=1", test_num);
            audio_A <= 16'h0000;
            audio_B <= 16'h1111;
            select <= 1'b1;
            @(posedge clk);
            #1;
            audio_B <= 16'h2222;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
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
        input [15:0] expected_output_audio;
        begin
            if (expected_output_audio === (expected_output_audio ^ output_audio ^ expected_output_audio)) begin
                $display("PASS");
                $display("  Outputs: output_audio=%h",
                         output_audio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_audio=%h",
                         expected_output_audio);
                $display("  Got:      output_audio=%h",
                         output_audio);
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
        $dumpvars(0,audio_A, audio_B, clk, select, output_audio);
    end

endmodule
