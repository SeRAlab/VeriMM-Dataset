`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg we;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_16bit dut (
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
        $display("Test %0d: Basic Write and Read at Address 0x5", test_num);
        reset_dut();


        addr = 4'h5;
        data_in = 16'hABCD;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        addr = 4'h5;
        #5;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary Address Check (0x0 and 0xF)", test_num);
        reset_dut();


        addr = 4'h0;
        data_in = 16'h1111;
        we = 1;
        @(posedge clk);


        addr = 4'hF;
        data_in = 16'hFFFF;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        addr = 4'hF;
        #5;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overwriting existing data", test_num);
        reset_dut();


        addr = 4'hA;
        data_in = 16'hAAAA;
        we = 1;
        @(posedge clk);


        addr = 4'hA;
        data_in = 16'h5555;
        we = 1;
        @(posedge clk);
        #1 we = 0;


        addr = 4'hA;
        #5;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify Write Enable signal (WE=0)", test_num);
        reset_dut();


        addr = 4'h3;
        data_in = 16'h7777;
        we = 1;
        @(posedge clk);


        we = 0;
        addr = 4'h3;
        data_in = 16'hEEEE;
        @(posedge clk);


        addr = 4'h3;
        #5;
        #1;

        check_outputs(16'h7777);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiple sequential writes followed by read", test_num);
        reset_dut();


        we = 1;
        addr = 4'h0; data_in = 16'h0001; @(posedge clk);
        addr = 4'h1; data_in = 16'h0002; @(posedge clk);
        addr = 4'h2; data_in = 16'h0004; @(posedge clk);
        #1 we = 0;


        addr = 4'h1;
        #5;
        #1;

        check_outputs(16'h0002);
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
