`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [15:0] b;
    reg ce;
    reg clk;
    wire [31:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ce = 0;
            a = 0;
            b = 0;
            repeat (5) @(posedge clk);
        end
        endtask
    task run_multiplier;

        input [31:0] val_a;
        input [15:0] val_b;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: a=%d (0x%h), b=%d (0x%h)", test_num, $signed(val_a), val_a, $signed(val_b), val_b);
            @(posedge clk);
            a = val_a;
            b = val_b;
            ce = 1;



            repeat (40) @(posedge clk);

            ce = 0;
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_multiplier(32'sd15, 16'sd10);
            #1;

            check_outputs(32'sd150);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_multiplier(32'sd25, -16'sd4);
            #1;

            check_outputs(-32'sd100);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_multiplier(-32'sd50, 16'sd20);
            #1;

            check_outputs(-32'sd1000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_multiplier(-32'sd12, -16'sd12);
            #1;

            check_outputs(32'sd144);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_multiplier(32'sd0, 16'sd999);
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            run_multiplier(32'sd2, 16'sh7FFF);
            #1;

            check_outputs(32'sd65534);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            run_multiplier(32'sd2, 16'sh8000);
            #1;

            check_outputs(-32'sd65536);
        end
        endtask

    task testcase008;

        begin
            reset_dut();

            run_multiplier(32'hFFFFFFFF, 16'sd5);
            #1;

            check_outputs(32'hFFFFFFF0 ^ 32'hFFFFFFF0 ^ 32'hFFFFFFFB);
        end
        endtask

    task testcase009;

        begin
            reset_dut();


            run_multiplier(32'sd1000000, 16'sd3000);
            #1;

            check_outputs(32'hB2D05E00);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_multiplier(32'sh12345678, 16'sd1);
            #1;

            check_outputs(32'sh12345678);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        testcase010();
        
        
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
        input [31:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
