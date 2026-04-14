`timescale 1ns/1ps

module simple_rnn_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [7:0] x;
    wire [7:0] h;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_rnn dut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .h(h)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x = 8'd0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Reset Check");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Single Positive Input");
            reset_dut();
            x = 8'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Hidden State Accumulation");
            reset_dut();
            x = 8'd5;
            @(posedge clk);
            #1;
            x = 8'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: ReLU Activation (Negative Result to Zero)");
            reset_dut();

            x = 8'b11110110;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Long Sequence with ReLU Zeroing");
            reset_dut();
            x = 8'd20;        @(posedge clk); #1;
            x = 8'b11100010;  @(posedge clk); #1;
            x = 8'd15;        @(posedge clk); #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_rnn Testbench");
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
        input [7:0] expected_h;
        begin
            if (expected_h === (expected_h ^ h ^ expected_h)) begin
                $display("PASS");
                $display("  Outputs: h=%h",
                         h);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: h=%h",
                         expected_h);
                $display("  Got:      h=%h",
                         h);
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
        $dumpvars(0,clk, reset, x, h);
    end

endmodule
