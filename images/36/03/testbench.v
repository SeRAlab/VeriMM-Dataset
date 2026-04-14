`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg clk;
    reg reset;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .clk(clk),
        .reset(reset),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            audio_in1 = 0;
            audio_in2 = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All zeros input", test_num);
            reset_dut();
            audio_in1 = 8'h00;
            audio_in2 = 8'h00;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Maximum values (255, 255)", test_num);
            reset_dut();
            audio_in1 = 8'hFF;
            audio_in2 = 8'hFF;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Even sum average (100, 200)", test_num);
            reset_dut();
            audio_in1 = 8'd100;
            audio_in2 = 8'd200;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Odd sum average (10, 11)", test_num);
            reset_dut();
            audio_in1 = 8'd10;
            audio_in2 = 8'd11;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Zero and Max (0, 255)", test_num);
            reset_dut();
            audio_in1 = 8'd0;
            audio_in2 = 8'd255;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd127);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset priority check", test_num);
            reset_dut();
            reset = 1;
            audio_in1 = 8'd200;
            audio_in2 = 8'd200;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
            reset = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Random arbitrary values (45, 132)", test_num);
            reset_dut();
            audio_in1 = 8'd45;
            audio_in2 = 8'd132;
            @(posedge clk);
            #1 #1;
 check_outputs(8'd88);
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
        input [7:0] expected_audio_out;
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
        $dumpvars(0,audio_in1, audio_in2, clk, reset, audio_out);
    end

endmodule
