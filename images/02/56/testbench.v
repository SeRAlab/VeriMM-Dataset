`timescale 1ns/1ps

module aes_round_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] data_in;
    reg [127:0] key;
    reg rst;
    wire [127:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aes_round dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 128'b0;
            key = 128'b0;
            @(posedge clk);
            @(posedge clk);
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            data_in = 128'h00000000000000000000000000000000;
            key     = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            $display("Test Case 001: All Zeros");
            #1;

            check_outputs(128'h63636363636363636363636363636363);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;

            key     = 128'ha0fafe1788542cb123a339392a6c7605;
            @(posedge clk);
            #1;
            $display("Test Case 002: NIST Round 1 standard vector");
            #1;

            check_outputs(128'ha49c7ff2689f352b6b5bea43026a5049);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data_in = 128'h193de3bea0f4e22b9ac68d2ae9f84808;
            key     = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            $display("Test Case 003: NIST Round 1 data with zero key");
            #1;

            check_outputs(128'h046681e5e0cb199a48f8d37a2806264c);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            data_in = 128'hffffffffffffffffffffffffffffffff;
            key     = 128'h00000000000000000000000000000000;
            @(posedge clk);
            #1;
            $display("Test Case 004: All Fs input");
            #1;

            check_outputs(128'h16161616161616161616161616161616);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aes_round Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [127:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, key, rst, data_out);
    end

endmodule
