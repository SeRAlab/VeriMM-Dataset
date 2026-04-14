`timescale 1ns/1ps

module fir_filter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] sample_in;
    wire [7:0] sample_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fir_filter dut (
        .clk(clk),
        .reset(reset),
        .sample_in(sample_in),
        .sample_out(sample_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            sample_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero Input", test_num);
            reset_dut();
            repeat (8) begin
                sample_in = 8'd0;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'd0);
        end
        endtask

    task testcase002;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Impulse Response", test_num);
            reset_dut();

            sample_in = 8'd10; @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);
            sample_in = 8'd0;  @(posedge clk);

            expected = 8'd10 * h[7];
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase003;

        reg [7:0] sum_coeffs;
        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Step Response", test_num);
            reset_dut();

            sum_coeffs = h[0] + h[1] + h[2] + h[3] + h[4] + h[5] + h[6] + h[7];

            repeat (8) begin
                sample_in = 8'd2;
                @(posedge clk);
            end

            expected = 8'd2 * sum_coeffs;
            #1 #1;
 check_outputs(expected);
        end
        endtask

    task testcase004;

        reg [7:0] expected;
        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Ramp Sequence", test_num);
            reset_dut();

            sample_in = 8'd1; @(posedge clk);
            sample_in = 8'd2; @(posedge clk);
            sample_in = 8'd3; @(posedge clk);
            sample_in = 8'd4; @(posedge clk);
            sample_in = 8'd5; @(posedge clk);
            sample_in = 8'd6; @(posedge clk);
            sample_in = 8'd7; @(posedge clk);
            sample_in = 8'd8; @(posedge clk);


            expected = (8'd8*h[0]) + (8'd7*h[1]) + (8'd6*h[2]) + (8'd5*h[3]) +
                       (8'd4*h[4]) + (8'd3*h[5]) + (8'd2*h[6]) + (8'd1*h[7]);

            #1 #1;
 check_outputs(expected);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fir_filter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [7:0] expected_sample_out;
        begin
            if (expected_sample_out === (expected_sample_out ^ sample_out ^ expected_sample_out)) begin
                $display("PASS");
                $display("  Outputs: sample_out=%h",
                         sample_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sample_out=%h",
                         expected_sample_out);
                $display("  Got:      sample_out=%h",
                         sample_out);
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
        $dumpvars(0,clk, reset, sample_in, sample_out);
    end

endmodule
