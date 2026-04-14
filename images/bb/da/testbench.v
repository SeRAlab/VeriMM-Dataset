`timescale 1ns/1ps

module Counter_8_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_val;
    reg rst;
    wire [7:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Counter_8_load dut (
        .clk(clk),
        .load(load),
        .load_val(load_val),
        .rst(rst),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            load_val = 8'h00;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial Reset");
            reset_dut();
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Counting Sequence (5 cycles)");
            reset_dut();
            repeat(5) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Load Specific Value (0xA5)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'hA5;
            @(posedge clk);
            #1 load = 0;
            @(negedge clk);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Count after Load");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'h10;
            @(posedge clk);
            #1 load = 0;
            repeat(3) @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'h13);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Roll-over from 0xFF to 0x00");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_val = 8'hFF;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Priority over Load signal");
            reset_dut();
            @(negedge clk);
            rst = 1;
            load = 1;
            load_val = 8'h55;
            @(posedge clk);
            #1 rst = 0;
            load = 0;
            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Counter_8_load Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        $dumpvars(0,clk, load, load_val, rst, Q);
    end

endmodule
