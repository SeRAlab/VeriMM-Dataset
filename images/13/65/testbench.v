`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg enable;
    reg read;
    reg write;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_16bit dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .read(read),
        .write(write),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        enable = 0;
        read = 0;
        write = 0;
        data_in = 16'h0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: Basic Write and Read (0xABCD)");
        reset_dut();


        enable = 1;
        write = 1;
        data_in = 16'hABCD;
        @(posedge clk);
        #1;


        write = 0;
        read = 1;
        #2;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: Enable Signal Write Protection");
        reset_dut();


        enable = 1;
        write = 1;
        data_in = 16'h1111;
        @(posedge clk);
        #1;


        enable = 0;
        write = 1;
        data_in = 16'hEEEE;
        @(posedge clk);
        #1;


        enable = 1;
        write = 0;
        read = 1;
        #2;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: Write Signal Control");
        reset_dut();


        enable = 1;
        write = 1;
        data_in = 16'h5555;
        @(posedge clk);
        #1;


        write = 0;
        data_in = 16'hAAAA;
        @(posedge clk);
        #1;


        read = 1;
        #2;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: Data Persistence");
        reset_dut();

        enable = 1;
        write = 1;
        data_in = 16'hF0F0;
        @(posedge clk);
        #1;

        write = 0;
        repeat (5) @(posedge clk);

        read = 1;
        #2;
        #1;

        check_outputs(16'hF0F0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Bus behavior when Read is Low");
        reset_dut();


        enable = 1;
        write = 1;
        data_in = 16'h9999;
        @(posedge clk);
        #1;




        write = 0;
        read = 0;
        #10;

        read = 1;
        #2;
        #1;

        check_outputs(16'h9999);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_16bit Testbench");
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
        $dumpvars(0,clk, data_in, enable, read, write, data_out);
    end

endmodule
