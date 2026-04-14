`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg we;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            data_in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Write and Read (Addr 0x01)", test_num);
            reset_dut();


            we = 1;
            addr = 8'h01;
            data_in = 32'hDEADBEEF;
            @(posedge clk); #1;


            we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Low Check", test_num);
            reset_dut();


            we = 1; addr = 8'h05; data_in = 32'h11111111;
            @(posedge clk); #1;


            we = 0; addr = 8'h05; data_in = 32'hEEEEEEEE;
            @(posedge clk); #1;


            we = 0; addr = 8'h05;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h11111111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-address Write/Read", test_num);
            reset_dut();


            we = 1; addr = 8'hAA; data_in = 32'hAAAA5555;
            @(posedge clk); #1;


            we = 1; addr = 8'hBB; data_in = 32'hBBBB6666;
            @(posedge clk); #1;


            we = 0; addr = 8'hAA;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Data Check", test_num);
            reset_dut();


            we = 1; addr = 8'h10; data_in = 32'h12345678;
            @(posedge clk); #1;


            we = 1; addr = 8'h10; data_in = 32'h87654321;
            @(posedge clk); #1;


            we = 0; addr = 8'h10;
            @(posedge clk); #1;

            #1;


            check_outputs(32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Address Check (0xFF)", test_num);
            reset_dut();

            we = 1; addr = 8'hFF; data_in = 32'hFFFFFFFF;
            @(posedge clk); #1;

            we = 0; addr = 8'hFF;
            @(posedge clk); #1;

            #1;


            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
