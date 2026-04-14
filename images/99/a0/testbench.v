`timescale 1ns/1ps

module pattern_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    wire pattern_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pattern_detector dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .pattern_detected(pattern_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Detecting 1010", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1011 (No Detection)", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 0000 (No Detection)", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern 1111 (No Detection)", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overlapping pattern 101010", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Leading zeros 001010", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupted pattern with Reset", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 reset = 1;
            @(posedge clk); #1 reset = 0; data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Long sequence 1101010", test_num);
            reset_dut();
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1 data_in = 1;
            @(posedge clk); #1 data_in = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pattern_detector Testbench");
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
        input expected_pattern_detected;
        begin
            if (expected_pattern_detected === (expected_pattern_detected ^ pattern_detected ^ expected_pattern_detected)) begin
                $display("PASS");
                $display("  Outputs: pattern_detected=%b",
                         pattern_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pattern_detected=%b",
                         expected_pattern_detected);
                $display("  Got:      pattern_detected=%b",
                         pattern_detected);
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
        $dumpvars(0,clk, data_in, reset, pattern_detected);
    end

endmodule
