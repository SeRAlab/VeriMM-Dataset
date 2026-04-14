`timescale 1ns/1ps

module sequence_detector_1101_tb;

    // Testbench signals (sequential circuit)
    reg areset;
    reg bit_in;
    reg clk;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sequence_detector_1101 dut (
        .areset(areset),
        .bit_in(bit_in),
        .clk(clk),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            bit_in = 0;
            repeat(2) @(posedge clk);
            #1 areset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Basic 1101 sequence", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Incomplete sequence 1100", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(0);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Leading zeros 0001101", test_num);
            reset_dut();
            send_bit(0);
            send_bit(0);
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Stuttering start 11101", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Overlapping sequence 1101101", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            #2;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset during sequence 11-(reset)-01", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);

            areset = 1;
            #15;
            areset = 0;
            send_bit(0);
            send_bit(1);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Continuous ones 11111", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(1);
            send_bit(1);
            send_bit(1);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Pulse width check (detected should drop)", test_num);
            reset_dut();
            send_bit(1);
            send_bit(1);
            send_bit(0);
            send_bit(1);
            send_bit(0);
            #2;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sequence_detector_1101 Testbench");
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
        input expected_detected;
        begin
            if (expected_detected === (expected_detected ^ detected ^ expected_detected)) begin
                $display("PASS");
                $display("  Outputs: detected=%b",
                         detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: detected=%b",
                         expected_detected);
                $display("  Got:      detected=%b",
                         detected);
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
        $dumpvars(0,areset, bit_in, clk, detected);
    end

endmodule
