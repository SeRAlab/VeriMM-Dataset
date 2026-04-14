`timescale 1ns/1ps

module serializer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] parallel_data;
    reg reset;
    reg shift_enable;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    serializer dut (
        .clk(clk),
        .parallel_data(parallel_data),
        .reset(reset),
        .shift_enable(shift_enable),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            shift_enable = 0;
            parallel_data = 8'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking reset state...", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Checking LSB of 8'h01...", test_num);
            reset_dut();
            parallel_data = 8'h01;
            shift_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Checking Bit 1 of 8'h02...", test_num);
            reset_dut();
            parallel_data = 8'h02;
            shift_enable = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Checking MSB (Bit 7) of 8'h80...", test_num);
            reset_dut();
            parallel_data = 8'h80;
            shift_enable = 1;
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Checking Bit 0 of 8'hAA...", test_num);
            reset_dut();
            parallel_data = 8'hAA;
            shift_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Checking Bit 1 of 8'hAA...", test_num);
            reset_dut();
            parallel_data = 8'hAA;
            shift_enable = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Checking Bit 4 of 8'hFF...", test_num);
            reset_dut();
            parallel_data = 8'hFF;
            shift_enable = 1;
            repeat(5) @(posedge clk);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Checking Bit 7 of 8'h00...", test_num);
            reset_dut();
            parallel_data = 8'h00;
            shift_enable = 1;
            repeat(8) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Checking shift_enable logic...", test_num);
            reset_dut();
            parallel_data = 8'hFF;
            shift_enable = 0;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("serializer Testbench");
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
        $dumpvars(0,clk, parallel_data, reset, shift_enable, serial_out);
    end

endmodule
