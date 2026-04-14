`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] in;
    reg reset;
    wire [7:0] checksum;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .reset(reset),
        .checksum(checksum),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin

            @(negedge reset);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros (0x00)", test_num);
            reset_dut();
            in = 8'h00;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFF, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones (0xFF)", test_num);
            reset_dut();
            in = 8'hFF;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hF7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (0x55)", test_num);
            reset_dut();
            in = 8'h55;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFB, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (0xAA)", test_num);
            reset_dut();
            in = 8'hAA;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFB, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit (0x01)", test_num);
            reset_dut();
            in = 8'h01;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFE, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High nibble (0xF0)", test_num);
            reset_dut();
            in = 8'hF0;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFB, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Three bits (0x07)", test_num);
            reset_dut();
            in = 8'h07;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hFC, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Seven bits (0x7F)", test_num);
            reset_dut();
            in = 8'h7F;
            @(posedge reset);
            #2;
            #1;

            check_outputs(8'hF8, 1'b0);
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
        input [7:0] expected_checksum;
        input expected_error;
        begin
            if (expected_checksum === (expected_checksum ^ checksum ^ expected_checksum) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: checksum=%h, error=%b",
                         checksum, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: checksum=%h, error=%b",
                         expected_checksum, expected_error);
                $display("  Got:      checksum=%h, error=%b",
                         checksum, error);
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
        $dumpvars(0,in, reset, checksum, error);
    end

endmodule
