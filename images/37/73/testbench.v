`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frequency_input;
    reg reset;
    wire [7:0] detected_pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .clk(clk),
        .frequency_input(frequency_input),
        .reset(reset),
        .detected_pitch(detected_pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frequency_input = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Check", test_num);
            reset_dut();
            frequency_input = 8'h00;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Low Frequency Detection", test_num);
            reset_dut();
            frequency_input = 8'h0A;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Frequency Detection", test_num);
            reset_dut();
            frequency_input = 8'hFF;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition Ascending", test_num);
            reset_dut();
            frequency_input = 8'h20;
            repeat(3) @(posedge clk);
            frequency_input = 8'h40;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Transition Descending", test_num);
            reset_dut();
            frequency_input = 8'hA0;
            repeat(3) @(posedge clk);
            frequency_input = 8'h15;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Stability Check", test_num);
            reset_dut();
            frequency_input = 8'h77;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'h77);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Rapid Fluctuation settling", test_num);
            reset_dut();
            frequency_input = 8'h10; @(posedge clk);
            frequency_input = 8'h20; @(posedge clk);
            frequency_input = 8'h30; @(posedge clk);
            frequency_input = 8'h40; @(posedge clk);
            frequency_input = 8'h50;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(8'h50);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detector Testbench");
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
        input [7:0] expected_detected_pitch;
        begin
            if (expected_detected_pitch === (expected_detected_pitch ^ detected_pitch ^ expected_detected_pitch)) begin
                $display("PASS");
                $display("  Outputs: detected_pitch=%h",
                         detected_pitch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected_pitch=%h",
                         expected_detected_pitch);
                $display("  Got:      detected_pitch=%h",
                         detected_pitch);
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
        $dumpvars(0,clk, frequency_input, reset, detected_pitch);
    end

endmodule
