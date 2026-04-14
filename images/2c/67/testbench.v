`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg mix_select;
    reg rst;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .mix_select(mix_select),
        .rst(rst),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        mix_select = 0;
        forever #5 mix_select = ~mix_select;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in1 = 8'h00;
            audio_in2 = 8'h00;
            #10;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Reset Priority", test_num);
            reset_dut();

            rst = 1;
            audio_in1 = 8'hAA;
            audio_in2 = 8'hBB;
            #5;
            #1;

            check_outputs(8'h00);
            rst = 0;
            #5;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Select Audio Input 1 (mix_select=0)", test_num);
            reset_dut();
            audio_in1 = 8'h12;
            audio_in2 = 8'h34;

            wait(mix_select == 1'b0);
            #2;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Select Audio Input 2 (mix_select=1)", test_num);
            reset_dut();
            audio_in1 = 8'hA5;
            audio_in2 = 8'h5A;
            wait(mix_select == 1'b1);
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Full Scale Input 1", test_num);
            reset_dut();
            audio_in1 = 8'hFF;
            audio_in2 = 8'h00;
            wait(mix_select == 1'b0);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Zero Input 2", test_num);
            reset_dut();
            audio_in1 = 8'hFF;
            audio_in2 = 8'h00;
            wait(mix_select == 1'b1);
            #2;
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,audio_in1, audio_in2, mix_select, rst, audio_out);
    end

endmodule
