`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 4'b0;
            b = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: 0 * 0");
            reset_dut();
            a = 4'd0;
            b = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 5 * 0");
            reset_dut();
            a = 4'd5;
            b = 4'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 1 * 1");
            reset_dut();
            a = 4'd1;
            b = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 15 * 1");
            reset_dut();
            a = 4'd15;
            b = 4'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 3 * 4");
            reset_dut();
            a = 4'd3;
            b = 4'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd12);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 15 * 15 (Max values)");
            reset_dut();
            a = 4'd15;
            b = 4'd15;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 10 * 10");
            reset_dut();
            a = 4'd10;
            b = 4'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 7 * 8");
            reset_dut();
            a = 4'd7;
            b = 4'd8;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd56);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: 2 * 13");
            reset_dut();
            a = 4'd2;
            b = 4'd13;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd26);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: 9 * 6");
            reset_dut();
            a = 4'd9;
            b = 4'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd54);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [7:0] expected_result;
        begin
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
        $dumpvars(0,a, b, clk, result);
    end

endmodule
