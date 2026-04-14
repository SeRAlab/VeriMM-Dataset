`timescale 1ns/1ps

module edge_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal;
    wire edge_detected;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    edge_detector dut (
        .clk(clk),
        .reset(reset),
        .signal(signal),
        .edge_detected(edge_detected)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            signal = 0;
            #15;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Detection of 0 to 1 transition...");
            reset_dut();
            signal = 0;
            @(posedge clk);
            #1 signal = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Signal remains high after detection...");
            reset_dut();
            signal = 0;
            @(posedge clk);
            #1 signal = 1;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Detection of 1 to 0 transition (falling edge)...");
            reset_dut();
            signal = 1;
            @(posedge clk);
            #1 signal = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Signal remains low...");
            reset_dut();
            signal = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Consecutive pulses...");
            reset_dut();

            signal = 0; @(posedge clk);
            #1 signal = 1; @(posedge clk);
            #1 signal = 0; @(posedge clk);

            #1 signal = 1; @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Reset during detection pulse...");
            reset_dut();
            signal = 0;
            @(posedge clk);
            #1 signal = 1;
            @(posedge clk);
            #2 reset = 1;
            #1 #1;
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
        $display("edge_detector Testbench");
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
        input expected_edge_detected;
        begin
            if (expected_edge_detected === (expected_edge_detected ^ edge_detected ^ expected_edge_detected)) begin
                $display("PASS");
                $display("  Outputs: edge_detected=%b",
                         edge_detected);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: edge_detected=%b",
                         expected_edge_detected);
                $display("  Got:      edge_detected=%b",
                         edge_detected);
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
        $dumpvars(0,clk, reset, signal, edge_detected);
    end

endmodule
