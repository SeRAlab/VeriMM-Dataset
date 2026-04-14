`timescale 1ns/1ps

module shift_register_32bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg load;
    reg reset;
    reg shift_left;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_32bit dut (
        .clk(clk),
        .data(data),
        .load(load),
        .reset(reset),
        .shift_left(shift_left),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            shift_left = 0;
            data = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Synchronous Reset Check");
            reset_dut();

            load = 1;
            data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            load = 0;

            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Load Check");
            reset_dut();
            load = 1;
            data = 32'hA5A5A5A5;
            @(posedge clk);
            #1;
            load = 0;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single Shift-Left Check");
            reset_dut();

            load = 1;
            data = 32'h00000001;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Shift-Left Check");
            reset_dut();

            load = 1;
            data = 32'h0000000F;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            repeat(4) @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(32'h000000F0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Priority Check (Reset over Load)");
            reset_dut();
            reset = 1;
            load = 1;
            data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            reset = 0;
            load = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Priority Check (Load over Shift)");
            reset_dut();

            load = 1;
            data = 32'h12345678;
            @(posedge clk);
            #1;

            load = 1;
            shift_left = 1;
            data = 32'hABCDEF01;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;

            #1;


            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Shift-Left MSB Overflow Check");
            reset_dut();

            load = 1;
            data = 32'h80000000;
            @(posedge clk);
            #1;
            load = 0;

            shift_left = 1;
            @(posedge clk);
            #1;
            shift_left = 0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Data Hold Check");
            reset_dut();
            load = 1;
            data = 32'h55AA55AA;
            @(posedge clk);
            #1;
            load = 0;
            shift_left = 0;
            reset = 0;

            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_32bit Testbench");
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
        input [31:0] expected_q;
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
        $dumpvars(0,clk, data, load, reset, shift_left, q);
    end

endmodule
