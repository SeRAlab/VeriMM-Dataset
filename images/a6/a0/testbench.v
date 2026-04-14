`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] wdata;
    reg we;
    wire [31:0] send_ena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .wdata(wdata),
        .we(we),
        .send_ena(send_ena)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we <= 1'b1;
            wdata <= 32'h0;
            @(negedge clk);
            we <= 1'b0;
            wdata <= 32'h0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Basic falling edge write");
            wdata <= 32'hDEADBEEF;
            we <= 1'b1;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Write enable low check");

            wdata <= 32'h12345678;
            we <= 1'b1;
            @(negedge clk);

            we <= 1'b0;
            wdata <= 32'hFFFFFFFF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Sequential writes");
            we <= 1'b1;
            wdata <= 32'hAAAA_AAAA;
            @(negedge clk);
            wdata <= 32'h5555_5555;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: All bits toggle high");
            we <= 1'b1;
            wdata <= 32'hFFFF_FFFF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Data retention over cycles");
            we <= 1'b1;
            wdata <= 32'hABCD_1234;
            @(negedge clk);
            we <= 1'b0;
            wdata <= 32'h0;
            repeat(3) @(negedge clk);
            #2;
            #1;

            check_outputs(32'hABCD_1234);
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
        input [31:0] expected_send_ena;
        begin
            if (expected_send_ena === (expected_send_ena ^ send_ena ^ expected_send_ena)) begin
                $display("PASS");
                $display("  Outputs: send_ena=%h",
                         send_ena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: send_ena=%h",
                         expected_send_ena);
                $display("  Got:      send_ena=%h",
                         send_ena);
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
        $dumpvars(0,clk, wdata, we, send_ena);
    end

endmodule
