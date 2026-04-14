`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [7:0] in_sample;
    reg rst;
    wire [7:0] out_sample;
    wire out_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .enable(enable),
        .in_sample(in_sample),
        .rst(rst),
        .out_sample(out_sample),
        .out_valid(out_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("\n--- Resetting DUT ---");
            rst = 1;
            enable = 0;
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
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic 4-sample sequence (1:4 decimation)", test_num);
            reset_dut();


            enable = 1; in_sample = 8'h10; @(posedge clk); #1;

            enable = 1; in_sample = 8'h20; @(posedge clk); #1;

            enable = 1; in_sample = 8'h30; @(posedge clk); #1;

            enable = 1; in_sample = 8'h40; @(posedge clk); #1;


            #1;



            check_outputs(8'h40, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequence with enable signal gaps", test_num);
            reset_dut();


            enable = 1; in_sample = 8'hA1; @(posedge clk); #1;

            enable = 0; in_sample = 8'hFF; @(posedge clk); #1;

            enable = 1; in_sample = 8'hA2; @(posedge clk); #1;

            enable = 0; in_sample = 8'hEE; @(posedge clk); #1;

            enable = 1; in_sample = 8'hA3; @(posedge clk); #1;

            enable = 1; in_sample = 8'hA4; @(posedge clk); #1;


            #1;



            check_outputs(8'hA4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Continuous streaming of two sample blocks", test_num);
            reset_dut();


            enable = 1; in_sample = 8'h01; @(posedge clk); #1;
            enable = 1; in_sample = 8'h02; @(posedge clk); #1;
            enable = 1; in_sample = 8'h03; @(posedge clk); #1;
            enable = 1; in_sample = 8'h04; @(posedge clk); #1;


            enable = 1; in_sample = 8'h05; @(posedge clk); #1;
            enable = 1; in_sample = 8'h06; @(posedge clk); #1;
            enable = 1; in_sample = 8'h07; @(posedge clk); #1;
            enable = 1; in_sample = 8'h08; @(posedge clk); #1;


            #1;



            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset mid-sequence check", test_num);
            reset_dut();


            enable = 1; in_sample = 8'hD1; @(posedge clk); #1;
            enable = 1; in_sample = 8'hD2; @(posedge clk); #1;


            rst = 1; @(posedge clk); #1;
            rst = 0;


            enable = 1; in_sample = 8'h11; @(posedge clk); #1;
            enable = 1; in_sample = 8'h22; @(posedge clk); #1;
            enable = 1; in_sample = 8'h33; @(posedge clk); #1;
            enable = 1; in_sample = 8'h44; @(posedge clk); #1;


            #1;



            check_outputs(8'h44, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: out_valid low between sample windows", test_num);
            reset_dut();


            enable = 1; in_sample = 8'h01; @(posedge clk); #1;
            enable = 1; in_sample = 8'h02; @(posedge clk); #1;
            enable = 1; in_sample = 8'h03; @(posedge clk); #1;
            enable = 1; in_sample = 8'h04; @(posedge clk); #1;


            enable = 1; in_sample = 8'h05; @(posedge clk); #1;


            #1;



            check_outputs(out_sample, 1'b0);
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
        input [7:0] expected_out_sample;
        input expected_out_valid;
        begin
            if (expected_out_sample === (expected_out_sample ^ out_sample ^ expected_out_sample) &&
                expected_out_valid === (expected_out_valid ^ out_valid ^ expected_out_valid)) begin
                $display("PASS");
                $display("  Outputs: out_sample=%h, out_valid=%b",
                         out_sample, out_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sample=%h, out_valid=%b",
                         expected_out_sample, expected_out_valid);
                $display("  Got:      out_sample=%h, out_valid=%b",
                         out_sample, out_valid);
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
        $dumpvars(0,clk, enable, in_sample, rst, out_sample, out_valid);
    end

endmodule
