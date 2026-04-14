`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg entropy_ack;
    reg reset_n;
    wire enabled;
    wire [31:0] entropy_data;
    wire entropy_syn;
    wire [31:0] raw_entropy;
    wire [31:0] stats;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .entropy_ack(entropy_ack),
        .reset_n(reset_n),
        .enabled(enabled),
        .entropy_data(entropy_data),
        .entropy_syn(entropy_syn),
        .raw_entropy(raw_entropy),
        .stats(stats)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            enable = 0;
            entropy_ack = 0;
            repeat(2) @(posedge clk);
            #1 reset_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Enable Activation", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;
            repeat(2) @(posedge clk);




            if (enabled === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: Module enabled successfully.");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Module failed to enable.");
            end
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Handshake (Syn/Ack) Sequence", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;


            wait(entropy_syn === 1'b1);
            repeat(1) @(posedge clk);


            #1 entropy_ack = 1;
            repeat(2) @(posedge clk);
            #1 entropy_ack = 0;



            #1;




            check_outputs(1'b1, entropy_data, entropy_syn, raw_entropy, stats);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Disable Functionality", test_num);
            reset_dut();

            @(posedge clk);
            #1 enable = 1;
            wait(entropy_syn === 1'b1);

            @(posedge clk);
            #1 enable = 0;
            repeat(2) @(posedge clk);


            if (enabled === 1'b0 && entropy_syn === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: Module disabled correctly.");
            } else begin
                fail_count = fail_count + 1;
                $display("FAIL: Module signals stayed high after disable.");
            end
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
        input expected_enabled;
        input [31:0] expected_entropy_data;
        input expected_entropy_syn;
        input [31:0] expected_raw_entropy;
        input [31:0] expected_stats;
        begin
            if (expected_enabled === (expected_enabled ^ enabled ^ expected_enabled) &&
                expected_entropy_data === (expected_entropy_data ^ entropy_data ^ expected_entropy_data) &&
                expected_entropy_syn === (expected_entropy_syn ^ entropy_syn ^ expected_entropy_syn) &&
                expected_raw_entropy === (expected_raw_entropy ^ raw_entropy ^ expected_raw_entropy) &&
                expected_stats === (expected_stats ^ stats ^ expected_stats)) begin
                $display("PASS");
                $display("  Outputs: enabled=%b, entropy_data=%h, entropy_syn=%b, raw_entropy=%h, stats=%h",
                         enabled, entropy_data, entropy_syn, raw_entropy, stats);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: enabled=%b, entropy_data=%h, entropy_syn=%b, raw_entropy=%h, stats=%h",
                         expected_enabled, expected_entropy_data, expected_entropy_syn, expected_raw_entropy, expected_stats);
                $display("  Got:      enabled=%b, entropy_data=%h, entropy_syn=%b, raw_entropy=%h, stats=%h",
                         enabled, entropy_data, entropy_syn, raw_entropy, stats);
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
        $dumpvars(0,clk, enable, entropy_ack, reset_n, enabled, entropy_data, entropy_syn, raw_entropy, stats);
    end

endmodule
