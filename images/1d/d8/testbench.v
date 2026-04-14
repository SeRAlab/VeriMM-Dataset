`timescale 1ns/1ps

module frac_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] input_frequency;
    reg reset;
    wire [15:0] output_frequency;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    frac_n_pll dut (
        .clk(clk),
        .input_frequency(input_frequency),
        .reset(reset),
        .output_frequency(output_frequency)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            input_frequency = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Low Frequency Input (Expecting Div 2)", test_num);
            reset_dut();
            input_frequency = 16'd1000;

            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High Frequency Input (Expecting Div 4)", test_num);
            reset_dut();
            input_frequency = 16'd4000;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Frequency (0)", test_num);
            reset_dut();
            input_frequency = 16'd0;
            repeat(5) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Frequency (65535)", test_num);
            reset_dut();
            input_frequency = 16'hFFFF;
            repeat(5) @(posedge clk);
            #2;

            #1;


            check_outputs(16'h3FFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: State Transition Toggling", test_num);
            reset_dut();


            input_frequency = 16'd800;
            repeat(3) @(posedge clk);


            input_frequency = 16'd8000;
            repeat(10) @(posedge clk);
            #2;
            #1;

            check_outputs(16'd2000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("frac_n_pll Testbench");
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
        input [15:0] expected_output_frequency;
        begin
            if (expected_output_frequency === (expected_output_frequency ^ output_frequency ^ expected_output_frequency)) begin
                $display("PASS");
                $display("  Outputs: output_frequency=%h",
                         output_frequency);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_frequency=%h",
                         expected_output_frequency);
                $display("  Got:      output_frequency=%h",
                         output_frequency);
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
        $dumpvars(0,clk, input_frequency, reset, output_frequency);
    end

endmodule
