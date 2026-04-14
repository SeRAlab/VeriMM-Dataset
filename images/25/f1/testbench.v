`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in_sample;
    reg rst;
    wire [7:0] out_sample1;
    wire [7:0] out_sample2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_sample(in_sample),
        .rst(rst),
        .out_sample1(out_sample1),
        .out_sample2(out_sample2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_sample = 8'h00;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero value input", test_num);
            reset_dut();
            in_sample = 8'h00;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Maximum value input", test_num);
            reset_dut();
            in_sample = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Bit pattern 10101010", test_num);
            reset_dut();
            in_sample = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Bit pattern 01010101", test_num);
            reset_dut();
            in_sample = 8'h55;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sequential values check", test_num);
            reset_dut();

            in_sample = 8'h12;
            @(posedge clk);

            #1 in_sample = 8'h34;
            @(posedge clk);
            #2;



            #1;




            check_outputs(8'h34, 8'h34);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Mid-range value", test_num);
            reset_dut();
            in_sample = 8'h7F;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h7F, 8'h7F);
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
        input [7:0] expected_out_sample1;
        input [7:0] expected_out_sample2;
        begin
            if (expected_out_sample1 === (expected_out_sample1 ^ out_sample1 ^ expected_out_sample1) &&
                expected_out_sample2 === (expected_out_sample2 ^ out_sample2 ^ expected_out_sample2)) begin
                $display("PASS");
                $display("  Outputs: out_sample1=%h, out_sample2=%h",
                         out_sample1, out_sample2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sample1=%h, out_sample2=%h",
                         expected_out_sample1, expected_out_sample2);
                $display("  Got:      out_sample1=%h, out_sample2=%h",
                         out_sample1, out_sample2);
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
        $dumpvars(0,clk, in_sample, rst, out_sample1, out_sample2);
    end

endmodule
