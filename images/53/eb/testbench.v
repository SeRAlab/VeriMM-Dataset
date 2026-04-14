`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr_in;
    reg rd_in;
    reg send_addr;
    wire [15:0] addr;
    wire rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_in(addr_in),
        .rd_in(rd_in),
        .send_addr(send_addr),
        .addr(addr),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        send_addr = 0;
        forever #5 send_addr = ~send_addr;
    end

        task reset_dut;

        begin
            addr_in = 16'h0;
            rd_in = 1'b0;

            @(negedge send_addr);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            addr_in = 16'hABCD;
            rd_in = 1'b0;

            @(negedge send_addr);
            #2;
            #1;

            check_outputs(16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            addr_in = 16'h1234;
            rd_in = 1'b1;
            @(negedge send_addr);
            #2;
            #1;

            check_outputs(16'h1234, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            addr_in = 16'hAAAA;
            @(negedge send_addr);
            #2;

            addr_in = 16'h5555;
            @(posedge send_addr);
            #2;

            #1;


            check_outputs(16'hAAAA, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            addr_in = 16'hEEEE;
            @(negedge send_addr);
            #2;

            @(posedge send_addr);
            rd_in = 1'b1;
            #2;

            #1;


            check_outputs(16'hEEEE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            addr_in = 16'h1111;
            @(negedge send_addr);
            #1;

            addr_in = 16'h2222;
            @(negedge send_addr);
            #1;

            addr_in = 16'h3333;
            rd_in = 1'b1;
            @(negedge send_addr);
            #2;

            #1;


            check_outputs(16'h3333, 1'b0);
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
        input [15:0] expected_addr;
        input expected_rd;
        begin
            if (expected_addr === (expected_addr ^ addr ^ expected_addr) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: addr=%h, rd=%b",
                         addr, rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h, rd=%b",
                         expected_addr, expected_rd);
                $display("  Got:      addr=%h, rd=%b",
                         addr, rd);
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
        $dumpvars(0,addr_in, rd_in, send_addr, addr, rd);
    end

endmodule
