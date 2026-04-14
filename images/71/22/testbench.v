`timescale 1ns/1ps

module seq_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data;
    wire detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    seq_detector dut (
        .clk(clk),
        .data(data),
        .detected(detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        data = 0;
        repeat(4) @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Basic 101 Sequence", test_num);
        reset_dut();
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: All Zeros", test_num);
        reset_dut();
        data = 0; @(posedge clk);
        data = 0; @(posedge clk);
        data = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Overlapping 10101", test_num);
        reset_dut();
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Partial Sequence 1101", test_num);
        reset_dut();
        data = 1; @(posedge clk);
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Broken Sequence 1001", test_num);
        reset_dut();
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Sequence 1011 (should be 0 at end)", test_num);
        reset_dut();
        data = 1; @(posedge clk);
        data = 0; @(posedge clk);
        data = 1; @(posedge clk);
        data = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("seq_detector Testbench");
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
        $dumpvars(0,clk, data, detected);
    end

endmodule
