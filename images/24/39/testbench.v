`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] compression_ratio;
    reg [9:0] in_signal;
    reg rst;
    reg [9:0] threshold;
    wire [7:0] out_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .clk(clk),
        .compression_ratio(compression_ratio),
        .in_signal(in_signal),
        .rst(rst),
        .threshold(threshold),
        .out_signal(out_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_signal = 0;
            threshold = 0;
            compression_ratio = 1;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Below Threshold (Positive)", test_num);
            reset_dut();
            threshold = 10'd50;
            compression_ratio = 4'd2;
            in_signal = 10'd20;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h14);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Above Threshold (Positive Compression)", test_num);
            reset_dut();
            threshold = 10'd40;
            compression_ratio = 4'd4;
            in_signal = 10'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h37);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Above Threshold (Negative Compression)", test_num);
            reset_dut();
            threshold = 10'd40;
            compression_ratio = 4'd4;
            in_signal = -10'd100;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hC9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Below Threshold (Negative)", test_num);
            reset_dut();
            threshold = 10'd60;
            compression_ratio = 4'd2;
            in_signal = -10'd30;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hE2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Saturation", test_num);
            reset_dut();
            threshold = 10'd100;
            compression_ratio = 4'd1;
            in_signal = 10'd500;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative Saturation", test_num);
            reset_dut();
            threshold = 10'd100;
            compression_ratio = 4'd1;
            in_signal = -10'd500;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Threshold", test_num);
            reset_dut();
            threshold = 10'd0;
            compression_ratio = 4'd8;
            in_signal = 10'd120;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h0F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: High Ratio (10:1)", test_num);
            reset_dut();
            threshold = 10'd20;
            compression_ratio = 4'd10;
            in_signal = 10'd420;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h3C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input [7:0] expected_out_signal;
        begin
            if (expected_out_signal === (expected_out_signal ^ out_signal ^ expected_out_signal)) begin
                $display("PASS");
                $display("  Outputs: out_signal=%h",
                         out_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal=%h",
                         expected_out_signal);
                $display("  Got:      out_signal=%h",
                         out_signal);
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
        $dumpvars(0,clk, compression_ratio, in_signal, rst, threshold, out_signal);
    end

endmodule
