`timescale 1ns/1ps

module divide_by_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] in_num;
    reg reset;
    wire [2:0] out_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divide_by_8 dut (
        .clk(clk),
        .in_num(in_num),
        .reset(reset),
        .out_num(out_num)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in_num = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Input = 0");
            reset_dut();
            in_num = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Input = 7 (Max 3-bit value)");
            reset_dut();
            in_num = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Input = 4");
            reset_dut();
            in_num = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Input = 1");
            reset_dut();
            in_num = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Input = 3");
            reset_dut();
            in_num = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divide_by_8 Testbench");
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
        input [2:0] expected_out_num;
        begin
            if (expected_out_num === (expected_out_num ^ out_num ^ expected_out_num)) begin
                $display("PASS");
                $display("  Outputs: out_num=%h",
                         out_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_num=%h",
                         expected_out_num);
                $display("  Got:      out_num=%h",
                         out_num);
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
        $dumpvars(0,clk, in_num, reset, out_num);
    end

endmodule
