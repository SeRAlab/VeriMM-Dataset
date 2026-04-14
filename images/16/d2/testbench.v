`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg [7:0] dest_addr;
    reg reset;
    reg [7:0] src_addr;
    reg start;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .data_in(data_in),
        .dest_addr(dest_addr),
        .reset(reset),
        .src_addr(src_addr),
        .start(start),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            src_addr = 0;
            dest_addr = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Transfer", test_num);
            reset_dut();

            src_addr = 8'h10;
            dest_addr = 8'h20;
            data_in = 16'hABCD;
            start = 1;

            @(posedge clk);
            #1 start = 0;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Start Low (No Transfer)", test_num);
            reset_dut();

            src_addr = 8'hAA;
            dest_addr = 8'hBB;
            data_in = 16'h5555;
            start = 0;

            @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Successive Transfers", test_num);
            reset_dut();

            src_addr = 8'h01;
            dest_addr = 8'h02;
            data_in = 16'h1111;
            start = 1;
            @(posedge clk);

            #1 data_in = 16'h2222;
            @(posedge clk);

            #1 start = 0;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset During Operation", test_num);
            reset_dut();

            data_in = 16'hFFFF;
            start = 1;
            @(posedge clk);
            #1;

            reset = 1;
            @(posedge clk);
            #1 reset = 0;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Data Stability (Start goes Low)", test_num);
            reset_dut();

            data_in = 16'hCAFE;
            start = 1;
            @(posedge clk);

            #1 start = 0;
            data_in = 16'hDEAD;
            @(posedge clk);

            #1;


            check_outputs(16'hCAFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, data_out);
    end

endmodule
