`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg c;
    wire [15:0] outcome;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .outcome(outcome)
    );

    // Clock generation (10ns period)
    initial begin
        c = 0;
        forever #5 c = ~c;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;

            @(posedge c);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd0;
            b = 8'd0;

            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 0 * 0", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd15;
            b = 8'd1;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 15 * 1", test_num);
            #1;

            check_outputs(16'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd5;
            b = 8'd4;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 5 * 4", test_num);
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd255;
            b = 8'd0;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 255 * 0", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd16;
            b = 8'd8;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 16 * 8", test_num);
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd255;
            b = 8'd255;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 255 * 255", test_num);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd12;
            b = 8'd12;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 12 * 12", test_num);
            #1;

            check_outputs(16'd144);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd13;
            b = 8'd7;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 13 * 7", test_num);
            #1;

            check_outputs(16'd91);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd128;
            b = 8'd1;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 128 * 1", test_num);
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            a = 8'd7;
            b = 8'd30;
            repeat(2) @(posedge c);
            #1;
            $display("Testcase %0d: 7 * 30", test_num);
            #1;

            check_outputs(16'd210);
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
        input [15:0] expected_outcome;
        begin
            if (expected_outcome === (expected_outcome ^ outcome ^ expected_outcome)) begin
                $display("PASS");
                $display("  Outputs: outcome=%h",
                         outcome);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outcome=%h",
                         expected_outcome);
                $display("  Got:      outcome=%h",
                         outcome);
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
        $dumpvars(0,a, b, c, outcome);
    end

endmodule
