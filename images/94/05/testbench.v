`timescale 1ns/1ps

module UD_counter_8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg rst_n;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UD_counter_8 dut (
        .clk(clk),
        .dir(dir),
        .rst_n(rst_n),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            dir = 0;
            @(negedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Condition");
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            $display("Testcase 002: Up count for 10 cycles");
            reset_dut();
            dir = 1;
            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Down count for 5 cycles");
            reset_dut();
            dir = 0;
            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Up 15, Down 5");
            reset_dut();
            dir = 1;
            repeat(15) @(posedge clk);
            dir = 0;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("Testcase 005: Wrap-around 255 to 0");
            reset_dut();
            dir = 1;
            repeat(256) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Wrap-around 0 to 255");
            reset_dut();
            dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Rapid toggle check");
            reset_dut();
            dir = 1; @(posedge clk);
            dir = 1; @(posedge clk);
            dir = 0; @(posedge clk);
            dir = 1; @(posedge clk);
            dir = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("UD_counter_8 Testbench");
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
        input [7:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,clk, dir, rst_n, Q);
    end

endmodule
