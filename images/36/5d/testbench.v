`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] sample_in;
    wire [15:0] sample_out1;
    wire [15:0] sample_out2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .rst(rst),
        .sample_in(sample_in),
        .sample_out1(sample_out1),
        .sample_out2(sample_out2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            sample_in = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Zero Input", test_num);
            reset_dut();
            sample_in = 16'h0000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Positive Step", test_num);
            reset_dut();
            sample_in = 16'h4000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h2000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Consecutive Samples (Ramp up)", test_num);
            reset_dut();
            sample_in = 16'h2000;
            @(posedge clk);
            sample_in = 16'h4000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h2000, 16'h3000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Decreasing Step", test_num);
            reset_dut();
            sample_in = 16'h6000;
            @(posedge clk);
            sample_in = 16'h2000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h6000, 16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Maximum Positive Signed Value", test_num);
            reset_dut();
            sample_in = 16'h7FFF;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'h3FFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Negative Value Step", test_num);
            reset_dut();
            sample_in = 16'hFFFE;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h0000, 16'hFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Max Positive to Max Negative Transition", test_num);
            reset_dut();
            sample_in = 16'h7FFF;
            @(posedge clk);
            sample_in = 16'h8000;
            @(posedge clk);
            #1 #1;
 check_outputs(16'h7FFF, 16'hFFFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
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
        input [15:0] expected_sample_out1;
        input [15:0] expected_sample_out2;
        begin
            if (expected_sample_out1 === (expected_sample_out1 ^ sample_out1 ^ expected_sample_out1) &&
                expected_sample_out2 === (expected_sample_out2 ^ sample_out2 ^ expected_sample_out2)) begin
                $display("PASS");
                $display("  Outputs: sample_out1=%h, sample_out2=%h",
                         sample_out1, sample_out2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sample_out1=%h, sample_out2=%h",
                         expected_sample_out1, expected_sample_out2);
                $display("  Got:      sample_out1=%h, sample_out2=%h",
                         sample_out1, sample_out2);
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
        $dumpvars(0,clk, rst, sample_in, sample_out1, sample_out2);
    end

endmodule
