`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] frac_val;
    reg [15:0] ref_freq;
    wire [15:0] out_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .frac_val(frac_val),
        .ref_freq(ref_freq),
        .out_freq(out_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Resetting DUT...");
            ref_freq = 16'h0;
            frac_val = 16'h0;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Integer Multiplier (N=2.0)", test_num);
            ref_freq = 16'd100;
            frac_val = 16'h0200;


            repeat (100) @(posedge clk);


            #1;



            check_outputs(16'd200);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Fractional Multiplier (N=1.5)", test_num);
            ref_freq = 16'd200;
            frac_val = 16'h0180;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(16'd300);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Small Fractional Step (N=1.25)", test_num);
            ref_freq = 16'd400;
            frac_val = 16'h0140;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(16'd500);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Fractional Down-scaling (N=0.5)", test_num);
            ref_freq = 16'd1000;
            frac_val = 16'h0080;

            repeat (100) @(posedge clk);


            #1;



            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Zero Reference Frequency", test_num);
            ref_freq = 16'd0;
            frac_val = 16'h0400;

            repeat (50) @(posedge clk);


            #1;



            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("\nTestcase %0d: Large Multiplier (N=10.0)", test_num);
            ref_freq = 16'd50;
            frac_val = 16'h0A00;

            repeat (150) @(posedge clk);


            #1;



            check_outputs(16'd500);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fractional_n_pll Testbench");
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
        input [15:0] expected_out_freq;
        begin
            if (expected_out_freq === (expected_out_freq ^ out_freq ^ expected_out_freq)) begin
                $display("PASS");
                $display("  Outputs: out_freq=%h",
                         out_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_freq=%h",
                         expected_out_freq);
                $display("  Got:      out_freq=%h",
                         out_freq);
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
        $dumpvars(0,clk, frac_val, ref_freq, out_freq);
    end

endmodule
