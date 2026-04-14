`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in_sample;
    reg rst;
    wire [3:0] out_sample;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
        .clk(clk),
        .in_sample(in_sample),
        .rst(rst),
        .out_sample(out_sample)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            in_sample = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            reset_dut();
            in_sample = 4'd0; @(posedge clk);
            in_sample = 4'd0; @(posedge clk);
            in_sample = 4'd0; @(posedge clk);
            in_sample = 4'd0; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Constant value 8", test_num);
            reset_dut();
            in_sample = 4'd8; @(posedge clk);
            in_sample = 4'd8; @(posedge clk);
            in_sample = 4'd8; @(posedge clk);
            in_sample = 4'd8; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple average (4, 12, 4, 12)", test_num);
            reset_dut();
            in_sample = 4'd4;  @(posedge clk);
            in_sample = 4'd12; @(posedge clk);
            in_sample = 4'd4;  @(posedge clk);
            in_sample = 4'd12; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Max values (15, 15, 15, 15)", test_num);
            reset_dut();
            in_sample = 4'd15; @(posedge clk);
            in_sample = 4'd15; @(posedge clk);
            in_sample = 4'd15; @(posedge clk);
            in_sample = 4'd15; @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Truncation check (1, 2, 3, 4) -> Avg 2.5", test_num);
            reset_dut();
            in_sample = 4'd1; @(posedge clk);
            in_sample = 4'd2; @(posedge clk);
            in_sample = 4'd3; @(posedge clk);
            in_sample = 4'd4; @(posedge clk);
            #2;

            #1;


            check_outputs(4'd2);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Single impulse (12, 0, 0, 0)", test_num);
            reset_dut();
            in_sample = 4'd12; @(posedge clk);
            in_sample = 4'd0;  @(posedge clk);
            in_sample = 4'd0;  @(posedge clk);
            in_sample = 4'd0;  @(posedge clk);
            #2;
            #1;

            check_outputs(4'd3);
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
        input [3:0] expected_out_sample;
        begin
            if (expected_out_sample === (expected_out_sample ^ out_sample ^ expected_out_sample)) begin
                $display("PASS");
                $display("  Outputs: out_sample=%h",
                         out_sample);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_sample=%h",
                         expected_out_sample);
                $display("  Got:      out_sample=%h",
                         out_sample);
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
        $dumpvars(0,clk, in_sample, rst, out_sample);
    end

endmodule
