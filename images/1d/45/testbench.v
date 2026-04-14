`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg clk;
    reg [15:0] data_in;
    reg re;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .re(re),
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
        address = 4'h0;
        data_in = 16'h0;
        re = 0;
        we = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: Basic Write/Read Addr 0", test_num);
        reset_dut();


        address = 4'h0;
        data_in = 16'hAAAA;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        address = 4'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Max Address Write/Read", test_num);
        reset_dut();


        address = 4'hF;
        data_in = 16'h5555;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        address = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Overwrite Memory", test_num);
        reset_dut();


        address = 4'h5;
        data_in = 16'h1234;
        we = 1;
        @(posedge clk);
        #1;

        data_in = 16'hABCD;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        address = 4'h5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Address Isolation", test_num);
        reset_dut();


        address = 4'h1;
        data_in = 16'h1111;
        we = 1;
        @(posedge clk);
        #1;

        address = 4'h2;
        data_in = 16'h2222;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        address = 4'h1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %03d: Write Enable Control", test_num);
        reset_dut();


        address = 4'h8;
        data_in = 16'hBEEF;
        we = 1;
        @(posedge clk);
        #1;


        we = 0;
        data_in = 16'hDEAD;
        @(posedge clk);
        #1;


        re = 1;
        address = 4'h8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %03d: Read Enable Toggle Persistence", test_num);
        reset_dut();


        address = 4'hA;
        data_in = 16'h7777;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        re = 1;
        @(posedge clk);
        #1 re = 0;
        @(posedge clk);
        #1 re = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_cell Testbench");
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
        $dumpvars(0,address, clk, data_in, re, we, data_out);
    end

endmodule
