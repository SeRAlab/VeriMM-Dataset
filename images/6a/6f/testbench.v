`timescale 1ns/1ps

module left_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    left_shift_register dut (
        .clear(clear),
        .clk(clk),
        .data(data),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            data = 8'h00;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            data = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            $display("Test Case 001: Synchronous Load 0xA5");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            data = 8'h01;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            @(posedge clk);
            #1;
            $display("Test Case 002: Single Left Shift (0x01 -> 0x02)");
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            data = 8'h07;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            repeat(3) @(posedge clk);
            #1;
            $display("Test Case 003: Triple Left Shift (0x07 -> 0x38)");
            #1;

            check_outputs(8'h38);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            data = 8'h80;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            @(posedge clk);
            #1;
            $display("Test Case 004: Shift MSB out (0x80 -> 0x00)");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            data = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            clear = 1;
            @(posedge clk);
            #1;
            $display("Test Case 005: Synchronous Clear");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            data = 8'h55;
            load = 1;
            clear = 1;
            @(posedge clk);
            #1;
            $display("Test Case 006: Clear Priority over Load");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            data = 8'h01;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            repeat(2) @(posedge clk);
            #1;

            data = 8'hEE;
            load = 1;
            @(posedge clk);
            #1;
            $display("Test Case 007: Load 0xEE after shifting");
            #1;

            check_outputs(8'hEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("left_shift_register Testbench");
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, data, load, q);
    end

endmodule
