`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        we = 0;
        forever #5 we = ~we;
    end

        task reset_dut;

    begin
        addr = 0;
        data_in = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        addr = 8'h01;
        data_in = 16'hABCD;
        #20;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        addr = 8'hFF;
        data_in = 16'h55AA;
        #20;
        #1;

        check_outputs(16'h55AA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();

        addr = 8'h10;
        data_in = 16'h1111;
        #20;

        addr = 8'h20;
        data_in = 16'h2222;
        #20;

        addr = 8'h10;
        #10;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        addr = 8'h05;
        data_in = 16'hAAAA;
        #20;
        data_in = 16'hBBBB;
        #20;
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        addr = 8'hEE;
        #10;
        #1;

        check_outputs(16'h0000);
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
        input [15:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, data_in, we, data_out);
    end

endmodule
