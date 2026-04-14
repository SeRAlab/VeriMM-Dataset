`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_A;
    reg [15:0] audio_B;
    reg clk;
    reg select;
    wire [15:0] audio_Y;

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
        .audio_Y(audio_Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            audio_A = 16'h0;
            audio_B = 16'h0;
            select = 0;
            @(posedge clk);
            #1;
            $display("DUT Reset/Initialized");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Input A", test_num);
            reset_dut();
            audio_A = 16'hABCD;
            audio_B = 16'h1234;
            select = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Select Input B", test_num);
            reset_dut();
            audio_A = 16'hABCD;
            audio_B = 16'h1234;
            select = 1;


            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dynamic Switching A to B", test_num);
            reset_dut();


            audio_A = 16'h5555;
            audio_B = 16'hAAAA;
            select = 0;
            @(posedge clk);


            select = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values", test_num);
            reset_dut();
            audio_A = 16'hFFFF;
            audio_B = 16'h0000;
            select = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Boundary Values Select B", test_num);
            reset_dut();
            audio_A = 16'hFFFF;
            audio_B = 16'h0000;
            select = 1;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input A noise while B selected", test_num);
            reset_dut();
            audio_B = 16'h7777;
            select = 1;


            audio_A = 16'h1111;
            #2;
            audio_A = 16'h2222;
            #2;
            audio_A = 16'h3333;

            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h7777);
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
        input [15:0] expected_audio_Y;
        begin
            if (expected_audio_Y === (expected_audio_Y ^ audio_Y ^ expected_audio_Y)) begin
                $display("PASS");
                $display("  Outputs: audio_Y=%h",
                         audio_Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_Y=%h",
                         expected_audio_Y);
                $display("  Got:      audio_Y=%h",
                         audio_Y);
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
        $dumpvars(0,audio_A, audio_B, clk, select, audio_Y);
    end

endmodule
