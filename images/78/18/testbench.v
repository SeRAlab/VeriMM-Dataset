`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] read_addr;
    reg wr;
    reg [7:0] write_addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .wr(wr),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            read_addr = 0;
            write_addr = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h10;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            wr = 0;
            read_addr = 8'h10;
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Write Enable (wr=0) Check", test_num);
            reset_dut();


            wr = 0;
            write_addr = 8'h20;
            write_data = 32'hCAFEBABE;
            @(posedge clk);
            #1;


            read_addr = 8'h20;
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Write/Read different addresses", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h01;
            write_data = 32'h11111111;
            @(posedge clk);
            #1;


            write_addr = 8'h02;
            write_data = 32'h22222222;
            read_addr = 8'h01;
            @(posedge clk);
            #1;


            read_addr = 8'h02;
            #2;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwriting existing data", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'hA0;
            write_data = 32'hAAAA_AAAA;
            @(posedge clk);
            #1;


            write_data = 32'hBBBB_BBBB;
            @(posedge clk);
            #1;

            read_addr = 8'hA0;
            #2;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Boundary Address Check", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'hFF;
            write_data = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;

            read_addr = 8'hFF;
            #2;
            #1;

            check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_addr, wr, write_addr, write_data, read_data);
    end

endmodule
