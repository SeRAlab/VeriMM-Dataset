`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [511:0] data_in;
    reg [8:0] read_address;
    reg read_enable;
    reg [8:0] write_address;
    reg write_enable;
    wire [511:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .read_address(read_address),
        .read_enable(read_enable),
        .write_address(write_address),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        write_enable = 0;
        read_enable = 0;
        write_address = 0;
        read_address = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Basic Write followed by Read", test_num);


        write_address = 9'd10;
        data_in = {16{32'hDEADBEEF}};
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_address = 9'd10;
        read_enable = 1;
        @(posedge clk);
        #1;
        read_enable = 0;

        #1;


        check_outputs({16{32'hDEADBEEF}});
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Write and Read at Boundary Address (511)", test_num);


        write_address = 9'd511;
        data_in = {16{32'hAAAA5555}};
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_address = 9'd511;
        read_enable = 1;
        @(posedge clk);
        #1;
        read_enable = 0;

        #1;


        check_outputs({16{32'hAAAA5555}});
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Verify Write Enable gating (Write when enable is low)", test_num);


        write_address = 9'd50;
        data_in = {16{32'hFFFFFFFF}};
        write_enable = 0;
        @(posedge clk);
        #1;


        read_address = 9'd50;
        read_enable = 1;
        @(posedge clk);
        #1;
        read_enable = 0;


        #1;



        check_outputs(512'h0);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Simultaneous Read and Write to different addresses", test_num);


        write_address = 9'd100;
        data_in = {16{32'h11111111}};
        write_enable = 1;
        @(posedge clk);
        #1;


        write_address = 9'd200;
        data_in = {16{32'h22222222}};
        write_enable = 1;
        read_address = 9'd100;
        read_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;
        read_enable = 0;


        #1;



        check_outputs({16{32'h11111111}});
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Sequential Read from different locations", test_num);


        write_address = 9'd20;
        data_in = {16{32'h12345678}};
        write_enable = 1;
        @(posedge clk);
        #1;


        write_address = 9'd21;
        data_in = {16{32'h87654321}};
        write_enable = 1;
        @(posedge clk);
        #1;
        write_enable = 0;


        read_address = 9'd20;
        read_enable = 1;
        @(posedge clk);
        #1;


        read_address = 9'd21;
        @(posedge clk);
        #1;
        read_enable = 0;


        #1;



        check_outputs({16{32'h87654321}});
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
        input [511:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, read_address, read_enable, write_address, write_enable, data_out);
    end

endmodule
