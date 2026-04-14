`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire msb_out;
    wire [3:0] shift_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .rst(rst),
        .serial_in(serial_in),
        .msb_out(msb_out),
        .shift_reg(shift_reg)
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
            serial_in = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Shift in 1111");
            reset_dut();

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;

            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Shift in 1010");
            reset_dut();

            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 4'b1010);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Walking bit (1000 -> 0001)");
            reset_dut();

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Overflow (5 shifts)");
            reset_dut();

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'b0111);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Reset during shifting");
            reset_dut();

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;

            @(negedge clk) rst = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b0, 4'b0000);
            @(negedge clk) rst = 0;
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
        input expected_msb_out;
        input [3:0] expected_shift_reg;
        begin
            if (expected_msb_out === (expected_msb_out ^ msb_out ^ expected_msb_out) &&
                expected_shift_reg === (expected_shift_reg ^ shift_reg ^ expected_shift_reg)) begin
                $display("PASS");
                $display("  Outputs: msb_out=%b, shift_reg=%h",
                         msb_out, shift_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: msb_out=%b, shift_reg=%h",
                         expected_msb_out, expected_shift_reg);
                $display("  Got:      msb_out=%b, shift_reg=%h",
                         msb_out, shift_reg);
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
        $dumpvars(0,clk, rst, serial_in, msb_out, shift_reg);
    end

endmodule
