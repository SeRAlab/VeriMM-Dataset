`timescale 1ns/1ps

module SRAM_16bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [15:0] data_in;
    reg wr_en;
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
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 4'h0;
            data_in = 16'h0000;
            wr_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read Back", test_num);


            addr = 4'h5;
            data_in = 16'hABCD;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            #5;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Multiple Writes, verify last", test_num);


            addr = 4'h0;
            data_in = 16'h1111;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 4'h1;
            data_in = 16'h2222;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 4'h0;
            wr_en = 0;
            #5;
            #1;

            check_outputs(16'h1111);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwriting memory location", test_num);


            addr = 4'hA;
            data_in = 16'hAAAA;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 4'hA;
            data_in = 16'h5555;
            wr_en = 1;
            @(posedge clk);
            #1;

            wr_en = 0;
            #5;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable signal verification", test_num);


            addr = 4'h7;
            data_in = 16'h7777;
            wr_en = 1;
            @(posedge clk);
            #1;


            addr = 4'h7;
            data_in = 16'hEEEE;
            wr_en = 0;
            @(posedge clk);
            #1;


            #5;
            #1;

            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Boundary address (4'hF)", test_num);

            addr = 4'hF;
            data_in = 16'hFFFF;
            wr_en = 1;
            @(posedge clk);
            #1;

            wr_en = 0;
            #5;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Data stability during read", test_num);


            addr = 4'h2;
            data_in = 16'h1234;
            wr_en = 1;
            @(posedge clk);
            #1;


            wr_en = 0;
            addr = 4'h2;
            data_in = 16'h9999;
            #5;
            #1;

            check_outputs(16'h1234);
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
        $dumpvars(0,addr, clk, data_in, wr_en, data_out);
    end

endmodule
