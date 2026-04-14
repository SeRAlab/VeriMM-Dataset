`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr;
    reg we_n;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .we_n(we_n),
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
        we_n = 1;
        write_addr = 0;
        write_data = 0;
        read_addr = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        write_addr = 4'h4;
        write_data = 8'hA5;
        we_n = 0;
        @(posedge clk);
        #1 we_n = 1;


        read_addr = 4'h4;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Active-low Write Enable Check", test_num);
        reset_dut();


        write_addr = 4'h7;
        write_data = 8'h11;
        we_n = 0;
        @(posedge clk);


        #1 we_n = 1;
        write_data = 8'hEE;
        @(posedge clk);


        #1 read_addr = 4'h7;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h11);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Overwriting Data", test_num);
        reset_dut();


        write_addr = 4'hA;
        write_data = 8'h33;
        we_n = 0;
        @(posedge clk);


        #1 write_data = 8'hCC;
        @(posedge clk);

        #1 we_n = 1;
        read_addr = 4'hA;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Boundary Address Check", test_num);
        reset_dut();


        write_addr = 4'h0;
        write_data = 8'h01;
        we_n = 0;
        @(posedge clk);


        #1 write_addr = 4'hF;
        write_data = 8'hFF;
        @(posedge clk);

        #1 we_n = 1;
        read_addr = 4'h0;
        @(posedge clk);

        #1 read_addr = 4'hF;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Simultaneous Read and Write", test_num);
        reset_dut();


        write_addr = 4'h1;
        write_data = 8'h55;
        we_n = 0;
        @(posedge clk);


        #1 write_addr = 4'h2;
        write_data = 8'hAA;
        read_addr = 4'h1;
        @(posedge clk);


        #1 #1;
 check_outputs(8'h55);
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
        input [7:0] expected_read_data;
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
        $dumpvars(0,clk, read_addr, we_n, write_addr, write_data, read_data);
    end

endmodule
