`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Memwrite;
    reg [3:0] address;
    reg clock;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Memwrite(Memwrite),
        .address(address),
        .clock(clock),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        Memwrite = 0;
        address = 0;
        write_data = 0;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Write and Read from Address 0", test_num);
        reset_dut();

        address = 4'h0;
        write_data = 32'hAAAA_BBBB;
        Memwrite = 1;
        @(posedge clock);
        #5;
        Memwrite = 0;
        #2;
        #1;

        check_outputs(32'hAAAA_BBBB);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Write and Read from Address 3", test_num);
        reset_dut();

        address = 4'h3;
        write_data = 32'h1234_5678;
        Memwrite = 1;
        @(posedge clock);
        #5;
        Memwrite = 0;
        #2;
        #1;

        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Overwrite data at Address 1", test_num);
        reset_dut();


        address = 4'h1;
        write_data = 32'h5555_5555;
        Memwrite = 1;
        @(posedge clock);
        #5;


        write_data = 32'hCCCC_DDDD;
        @(posedge clock);
        #5;
        Memwrite = 0;
        #2;
        #1;

        check_outputs(32'hCCCC_DDDD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Verify Memwrite=0 prevents data change", test_num);
        reset_dut();


        address = 4'h2;
        write_data = 32'h8888_8888;
        Memwrite = 1;
        @(posedge clock);
        #5;


        write_data = 32'h0000_0000;
        Memwrite = 0;
        @(posedge clock);
        #5;

        address = 4'h2;
        #2;
        #1;

        check_outputs(32'h8888_8888);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Verify asynchronous/continuous read behavior", test_num);
        reset_dut();


        address = 4'h0;
        write_data = 32'h1111_1111;
        Memwrite = 1;
        @(posedge clock);
        #2;
        address = 4'h1;
        write_data = 32'h2222_2222;
        @(posedge clock);
        #5;
        Memwrite = 0;


        address = 4'h0;
        #2;
        #1;

        check_outputs(32'h1111_1111);
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
        $dumpvars(0,Memwrite, address, clock, write_data, read_data);
    end

endmodule
