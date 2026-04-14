`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset at time %0t", $time);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Shifting in all 1s...", test_num);
            reset_dut();

            repeat(5) begin
                @(posedge clk);
                serial_in = 1;
            end
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Shift a single 1 through 5 cycles...", test_num);
            reset_dut();
            @(posedge clk); serial_in = 1;
            @(posedge clk); serial_in = 0;
            @(posedge clk); serial_in = 0;
            @(posedge clk); serial_in = 0;
            @(posedge clk); serial_in = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Shift all 0s...", test_num);
            reset_dut();
            repeat(5) begin
                @(posedge clk);
                serial_in = 0;
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating pattern 10101...", test_num);
            reset_dut();
            @(posedge clk); serial_in = 1;
            @(posedge clk); serial_in = 0;
            @(posedge clk); serial_in = 1;
            @(posedge clk); serial_in = 0;
            @(posedge clk); serial_in = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reset verification...", test_num);
            reset_dut();

            repeat(3) begin
                @(posedge clk);
                serial_in = 1;
            end

            rst = 1;
            @(posedge clk);
            rst = 0;

            repeat(2) begin
                @(posedge clk);
                serial_in = 0;
            end
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Propagation of 6th bit (0 -> 1 -> ... -> 0)...", test_num);
            reset_dut();






            repeat(4) begin
                @(posedge clk); serial_in = 0;
            end
            @(posedge clk); serial_in = 1;
            @(posedge clk); serial_in = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("siso_shift_register Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, rst, serial_in, serial_out);
    end

endmodule
