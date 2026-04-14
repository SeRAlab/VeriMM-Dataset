`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] sample;
    reg [7:0] threshold;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .threshold(threshold),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sample = 0;
            threshold = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            threshold = 8'd100;

            repeat(5) begin
                sample = 8'd150;
                @(posedge clk);
            end

            reset = 1;
            #1 #1;
 check_outputs(8'd5);
            @(posedge clk);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            threshold = 8'd50;

            repeat(3) begin
                sample = 8'd60;
                @(posedge clk);
            end

            sample = 8'd40;
            @(posedge clk);

            repeat(2) begin
                sample = 8'd60;
                @(posedge clk);
            end

            reset = 1;
            #1 #1;
 check_outputs(8'd2);
            @(posedge clk);
            reset = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            threshold = 8'd80;

            repeat(4) begin
                sample = 8'd80;
                @(posedge clk);
            end
            reset = 1;
            #1 #1;
 check_outputs(8'd0);
            @(posedge clk);
            reset = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            threshold = 8'd200;
            repeat(10) begin
                sample = 8'd100;
                @(posedge clk);
            end
            reset = 1;
            #1 #1;
 check_outputs(8'd0);
            @(posedge clk);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            threshold = 8'd10;
            repeat(25) begin
                sample = 8'd20;
                @(posedge clk);
            end
            reset = 1;
            #1 #1;
 check_outputs(8'd25);
            @(posedge clk);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            reset = 1;
            #1 #1;
 check_outputs(8'd0);
            @(posedge clk);
            reset = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detection Testbench");
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
        input [7:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, reset, sample, threshold, count);
    end

endmodule
