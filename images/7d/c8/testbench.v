`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] read_addr0;
    reg [7:0] read_addr1;
    reg wr;
    reg [7:0] write_addr;
    reg [31:0] write_data;
    wire [31:0] read_data0;
    wire [31:0] read_data1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr0(read_addr0),
        .read_addr1(read_addr1),
        .wr(wr),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data0(read_data0),
        .read_data1(read_data1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            write_addr = 0;
            write_data = 0;
            read_addr0 = 0;
            read_addr1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual Port Read (Same Address)", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h0A;
            write_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            wr = 0;
            read_addr0 = 8'h0A;
            read_addr1 = 8'h0A;


            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Read different addresses on different ports", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h01;
            write_data = 32'h11112222;
            @(posedge clk);
            #1;


            write_addr = 8'hFF;
            write_data = 32'hAAAA5555;
            @(posedge clk);
            #1;


            wr = 0;
            read_addr0 = 8'h01;
            read_addr1 = 8'hFF;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h11112222, 32'hAAAA5555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Write Enable (wr) signal", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h20;
            write_data = 32'hBCBCBCBC;
            @(posedge clk);
            #1;


            wr = 0;
            write_addr = 8'h20;
            write_data = 32'h00000000;
            @(posedge clk);
            #1;


            read_addr0 = 8'h20;
            read_addr1 = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hBCBCBCBC, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (0x00 and 0xFF)", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h00;
            write_data = 32'h12344321;
            @(posedge clk);
            #1;


            write_addr = 8'hFF;
            write_data = 32'h87655678;
            @(posedge clk);
            #1;


            wr = 0;
            read_addr0 = 8'hFF;
            read_addr1 = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h87655678, 32'h12344321);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Rapid sequential operations", test_num);
            reset_dut();


            wr = 1;
            write_addr = 8'h50;
            write_data = 32'hCAFEF00D;
            @(posedge clk);
            #1;


            wr = 1;
            write_addr = 8'h51;
            write_data = 32'hFEEDFACE;
            read_addr0 = 8'h50;
            @(posedge clk);
            #1;


            wr = 0;
            read_addr1 = 8'h51;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hCAFEF00D, 32'hFEEDFACE);
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
        input [31:0] expected_read_data0;
        input [31:0] expected_read_data1;
        begin
            if (expected_read_data0 === (expected_read_data0 ^ read_data0 ^ expected_read_data0) &&
                expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1)) begin
                $display("PASS");
                $display("  Outputs: read_data0=%h, read_data1=%h",
                         read_data0, read_data1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data0=%h, read_data1=%h",
                         expected_read_data0, expected_read_data1);
                $display("  Got:      read_data0=%h, read_data1=%h",
                         read_data0, read_data1);
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
        $dumpvars(0,clk, read_addr0, read_addr1, wr, write_addr, write_data, read_data0, read_data1);
    end

endmodule
