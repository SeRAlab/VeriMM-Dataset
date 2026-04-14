`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] in;
    reg reset;
    wire [127:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            in = 128'h0;
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Post-reset initial state", test_num);
            reset_dut();
            in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            @(posedge clk);

            #1;


            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit high-to-low transition", test_num);
            reset_dut();
            @(posedge clk);
            in = 128'h1;
            @(posedge clk);
            in = 128'h0;
            @(posedge clk);
            #1;

            check_outputs(128'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple bits high-to-low transition", test_num);
            reset_dut();
            @(posedge clk);
            in = 128'hA0A0_0000_0000_0000_5050_0000_0000_000F;
            @(posedge clk);
            in = 128'h0000_0000_0000_0000_0000_0000_0000_0000;
            @(posedge clk);
            #1;

            check_outputs(128'hA0A0_0000_0000_0000_5050_0000_0000_000F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rising edge check", test_num);
            reset_dut();
            @(posedge clk);
            in = 128'h0;
            @(posedge clk);
            in = 128'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            @(posedge clk);
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Output retention check", test_num);
            reset_dut();
            @(posedge clk);
            in = 128'hF;
            @(posedge clk);
            in = 128'hE;
            @(posedge clk);
            in = 128'hC;
            @(posedge clk);
            in = 128'hF;
            @(posedge clk);

            #1;


            check_outputs(128'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 127 falling edge", test_num);
            reset_dut();
            @(posedge clk);
            in = (128'h1 << 127);
            @(posedge clk);
            in = 128'h0;
            @(posedge clk);
            #1;

            check_outputs(128'h1 << 127);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All 128 bits falling edge", test_num);
            reset_dut();
            @(posedge clk);
            in = {64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF};
            @(posedge clk);
            in = 128'h0;
            @(posedge clk);
            #1;

            check_outputs({64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF});
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
        input [127:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
