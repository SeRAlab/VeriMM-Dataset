`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs;
    reg [3:0] ctl;
    reg [7:0] data;
    reg we;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .ctl(ctl),
        .data(data),
        .we(we),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

        begin
            cs = 0;
            ctl = 0;
            data = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Write and Multiply", test_num);


            cs = 1;
            ctl = 4'h1;
            data = 8'd10;
            @(posedge we);
            #2;


            data = 8'd5;
            #5;
            #1;

            check_outputs(16'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Chip Select Disable", test_num);


            cs = 1;
            ctl = 4'h2;
            data = 8'd20;
            @(posedge we);
            #2;


            cs = 0;
            data = 8'd2;
            #5;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Memory Persistence", test_num);


            cs = 1; ctl = 4'h3; data = 8'd100;
            @(posedge we); #2;


            ctl = 4'h4; data = 8'd50;
            @(posedge we); #2;


            ctl = 4'h3; data = 8'd2;
            #5;
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Zero Multiplier", test_num);

            cs = 1; ctl = 4'h5; data = 8'd255;
            @(posedge we); #2;

            data = 8'd0;
            #5;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Maximum Values", test_num);

            cs = 1; ctl = 4'hF; data = 8'd255;
            @(posedge we); #2;

            data = 8'd255;
            #5;
            #1;

            check_outputs(16'd65025);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
        $dumpvars(0,cs, ctl, data, we, out);
    end

endmodule
