`timescale 1ns/1ps

module shift_register_8bit_with_load_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] load_value;
    reg rst;
    reg shift_dir;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register_8bit_with_load dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .rst(rst),
        .shift_dir(shift_dir),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task init_signals;

        begin
            load = 0;
            load_value = 8'h00;
            rst = 0;
            shift_dir = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Reset Verification");
            init_signals();
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Parallel Load 0xA5");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'hA5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Left Shift (4 positions)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h01;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            shift_dir = 1;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h10);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Right Shift (4 positions)");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h80;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            shift_dir = 0;
            repeat(4) @(posedge clk);
            #1;

            #1;


            check_outputs(8'h08);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Left Shift Overflow");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'hC0;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            shift_dir = 1;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Right Shift Underflow");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h03;
            @(posedge clk);
            @(negedge clk);
            load = 0;
            shift_dir = 0;
            @(posedge clk);
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Load Priority over Shift");
            reset_dut();
            @(negedge clk);
            load = 1;
            load_value = 8'h55;
            shift_dir = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h55);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register_8bit_with_load Testbench");
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
        $dumpvars(0,clk, load, load_value, rst, shift_dir, q);
    end

endmodule
