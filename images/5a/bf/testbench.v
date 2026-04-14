`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] read_addr;
    reg read_en;
    reg [8:0] write_addr;
    reg [7:0] write_bytes;
    reg [63:0] write_data;
    reg write_en;
    wire [63:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .read_en(read_en),
        .write_addr(write_addr),
        .write_bytes(write_bytes),
        .write_data(write_data),
        .write_en(write_en),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        read_addr = 0;
        read_en = 0;
        write_addr = 0;
        write_bytes = 0;
        write_data = 0;
        write_en = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Full Word Write and Read", test_num);
        reset_dut();


        write_en = 1;
        write_bytes = 8'hFF;
        write_addr = 9'h00A;
        write_data = 64'hABCDEF0123456789;
        @(posedge clk);
        #1;
        write_en = 0;


        read_en = 1;
        read_addr = 9'h00A;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'hABCDEF0123456789);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Selective Byte Enable Write", test_num);
        reset_dut();


        write_en = 1;
        write_bytes = 8'hFF;
        write_addr = 9'h01F;
        write_data = 64'h0;
        @(posedge clk);
        #1;



        write_en = 1;
        write_bytes = 8'h55;
        write_addr = 9'h01F;
        write_data = 64'hAABBCCDDEEFF1122;
        @(posedge clk);
        #1;
        write_en = 0;


        read_en = 1;
        read_addr = 9'h01F;
        @(posedge clk);
        #1;

        #1;


        check_outputs(64'h00BB00DD00FF0022);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Sequential Access Multiple Addresses", test_num);
        reset_dut();


        write_en = 1;
        write_bytes = 8'hFF;
        write_addr = 9'h001;
        write_data = 64'h1111111111111111;
        @(posedge clk);
        #1;


        write_addr = 9'h002;
        write_data = 64'h2222222222222222;
        @(posedge clk);
        #1;
        write_en = 0;


        read_en = 1;
        read_addr = 9'h001;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'h1111111111111111);


        read_addr = 9'h002;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'h2222222222222222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Byte Modification", test_num);
        reset_dut();


        write_en = 1;
        write_bytes = 8'hFF;
        write_addr = 9'h050;
        write_data = 64'hAAAAAAAAAAAAAAAA;
        @(posedge clk);
        #1;


        write_bytes = 8'h80;
        write_data = 64'hFF00000000000000;
        @(posedge clk);
        #1;
        write_en = 0;


        read_en = 1;
        read_addr = 9'h050;
        @(posedge clk);
        #1;

        #1;


        check_outputs(64'hFFAAAAAAAAAAAAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Memory Boundary Test (Max Address)", test_num);
        reset_dut();


        write_en = 1;
        write_bytes = 8'hFF;
        write_addr = 9'h1FF;
        write_data = 64'hCAFEBABEDEADBEEF;
        @(posedge clk);
        #1;
        write_en = 0;


        read_en = 1;
        read_addr = 9'h1FF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(64'hCAFEBABEDEADBEEF);
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
        input [63:0] expected_read_data;
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
        $dumpvars(0,clk, read_addr, read_en, write_addr, write_bytes, write_data, write_en, read_data);
    end

endmodule
