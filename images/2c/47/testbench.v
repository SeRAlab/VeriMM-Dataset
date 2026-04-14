`timescale 1ns/1ps

module fractional_n_pll_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frac_div;
    reg [7:0] ref_freq;
    reg reset;
    wire [7:0] vco_freq;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fractional_n_pll dut (
        .clk(clk),
        .frac_div(frac_div),
        .ref_freq(ref_freq),
        .reset(reset),
        .vco_freq(vco_freq)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frac_div = 0;
            ref_freq = 0;
            repeat(2) @(posedge clk);
            #2 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Integer Division (100/2)", test_num);
            ref_freq = 8'd100;
            frac_div = 8'd2;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Higher Integer Division (200/4)", test_num);
            ref_freq = 8'd200;
            frac_div = 8'd4;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Unity Division (75/1)", test_num);
            ref_freq = 8'd75;
            frac_div = 8'd1;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd75);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Fractional-N result check (125/3)", test_num);
            ref_freq = 8'd125;
            frac_div = 8'd3;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd41);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Max Input range (255/5)", test_num);
            ref_freq = 8'd255;
            frac_div = 8'd5;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd51);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: High divisor check (240/80)", test_num);
            ref_freq = 8'd240;
            frac_div = 8'd80;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(8'd3);
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
        input [7:0] expected_vco_freq;
        begin
            if (expected_vco_freq === (expected_vco_freq ^ vco_freq ^ expected_vco_freq)) begin
                $display("PASS");
                $display("  Outputs: vco_freq=%h",
                         vco_freq);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: vco_freq=%h",
                         expected_vco_freq);
                $display("  Got:      vco_freq=%h",
                         vco_freq);
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
        $dumpvars(0,clk, frac_div, ref_freq, reset, vco_freq);
    end

endmodule
