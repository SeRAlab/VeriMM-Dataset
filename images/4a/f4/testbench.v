`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg write;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .write(write),
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
            address = 0;
            write_data = 0;
            write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Aligned Write and Read at Address 0", test_num);
            reset_dut();
            address = 32'h0;
            write_data = 32'hDEADBEEF;
            write = 1;
            @(negedge clk);
            #1 write = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Aligned Write and Read at Boundary (Addr 1020)", test_num);
            reset_dut();
            address = 32'd1020;
            write_data = 32'h55AA55AA;
            write = 1;
            @(negedge clk);
            #1 write = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Verify Write Enable Functionality", test_num);
            reset_dut();

            address = 32'h100;
            write_data = 32'h11111111;
            write = 1;
            @(negedge clk);

            #1 write = 0;
            write_data = 32'h22222222;
            @(negedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Data Overwrite Test", test_num);
            reset_dut();
            address = 32'h200;
            write_data = 32'hAAAA_AAAA;
            write = 1;
            @(negedge clk);
            #1 write_data = 32'hBBBB_BBBB;
            @(negedge clk);
            #1 write = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Persistent Storage Test across Addresses", test_num);
            reset_dut();

            address = 32'h10;
            write_data = 32'h12345678;
            write = 1;
            @(negedge clk);

            #1 address = 32'h14;
            write_data = 32'h9ABCDEF0;
            @(negedge clk);

            #1 write = 0;
            address = 32'h10;
            @(posedge clk);
            #1 #1;
 check_outputs(32'h12345678);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Unaligned Byte Address Read/Write (Addr 2)", test_num);
            reset_dut();
            address = 32'h2;
            write_data = 32'hCAFEBABE;
            write = 1;
            @(negedge clk);
            #1 write = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(32'hCAFEBABE);
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
        $dumpvars(0,address, clk, write, write_data, read_data);
    end

endmodule
