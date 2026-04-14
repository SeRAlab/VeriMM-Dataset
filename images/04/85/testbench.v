`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg [31:0] dest_addr;
    reg reset;
    reg [31:0] src_addr;
    reg start;
    wire [31:0] data_out;
    wire done;

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
        .data_out(data_out),
        .done(done)
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
            repeat (2) @(posedge clk);
            #1 reset = 0;
            repeat (1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Data Transfer (0x12345678)");
            test_num = 1;
            reset_dut();

            src_addr = 32'h0000_1000;
            dest_addr = 32'h0000_2000;
            data_in = 32'h1234_5678;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;


            while (done === 0) @(posedge clk);

            #1;


            check_outputs(32'h1234_5678, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Transfer Hex Pattern (0xDEADBEEF)");
            test_num = 2;
            reset_dut();

            src_addr = 32'h0000_AAAA;
            dest_addr = 32'h0000_BBBB;
            data_in = 32'hDEAD_BEEF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 0) @(posedge clk);

            #1;


            check_outputs(32'hDEAD_BEEF, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Transfer All Zeros");
            test_num = 3;
            reset_dut();

            src_addr = 32'h0000_0000;
            dest_addr = 32'hFFFF_FFFF;
            data_in = 32'h0000_0000;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 0) @(posedge clk);

            #1;


            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Transfer All Ones");
            test_num = 4;
            reset_dut();

            src_addr = 32'h1111_2222;
            dest_addr = 32'h3333_4444;
            data_in = 32'hFFFF_FFFF;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 0) @(posedge clk);

            #1;


            check_outputs(32'hFFFF_FFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Alternating Bit Pattern (0x5555AAAA)");
            test_num = 5;
            reset_dut();

            src_addr = 32'h0000_0001;
            dest_addr = 32'h0000_0002;
            data_in = 32'h5555_AAAA;

            @(posedge clk);
            #1 start = 1;
            @(posedge clk);
            #1 start = 0;

            while (done === 0) @(posedge clk);

            #1;


            check_outputs(32'h5555_AAAA, 1'b1);
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
        input [31:0] expected_data_out;
        input expected_done;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_done === (expected_done ^ done ^ expected_done)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, done=%b",
                         data_out, done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, done=%b",
                         expected_data_out, expected_done);
                $display("  Got:      data_out=%h, done=%b",
                         data_out, done);
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
        $dumpvars(0,clk, data_in, dest_addr, reset, src_addr, start, data_out, done);
    end

endmodule
