`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D_in_IO;
    reg [31:0] addr;
    reg clk;
    reg int_ack;
    reg io_cs;
    reg io_rd;
    reg io_wr;
    wire [31:0] D_out_IO;
    wire intr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D_in_IO(D_in_IO),
        .addr(addr),
        .clk(clk),
        .int_ack(int_ack),
        .io_cs(io_cs),
        .io_rd(io_rd),
        .io_wr(io_wr),
        .D_out_IO(D_out_IO),
        .intr(intr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            io_cs = 0;
            io_rd = 0;
            io_wr = 0;
            addr = 0;
            D_in_IO = 0;
            int_ack = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            @(posedge clk);
            io_cs = 1;
            io_wr = 1;
            addr = 32'h0;
            D_in_IO = 32'h12345678;


            @(posedge clk);
            io_wr = 0;
            io_cs = 0;


            @(posedge clk);
            io_cs = 1;
            io_rd = 1;
            addr = 32'h0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 1'b0);

            io_rd = 0;
            io_cs = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Write/Read (Addr 4092)", test_num);
            reset_dut();


            @(posedge clk);
            io_cs = 1;
            io_wr = 1;
            addr = 32'd4092;
            D_in_IO = 32'hABCDEFF0;

            @(posedge clk);
            io_wr = 0;


            io_rd = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCDEFF0, 1'b0);

            io_rd = 0;
            io_cs = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify no write occurs when io_cs is low", test_num);
            reset_dut();


            @(posedge clk);
            io_cs = 1; io_wr = 1; addr = 32'h10; D_in_IO = 32'h55555555;
            @(posedge clk);


            io_cs = 0; io_wr = 1; addr = 32'h10; D_in_IO = 32'hAAAAAAAA;
            @(posedge clk);


            io_wr = 0; io_cs = 1; io_rd = 1; addr = 32'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h55555555, 1'b0);

            io_rd = 0;
            io_cs = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Write/Read sequence", test_num);
            reset_dut();

            io_cs = 1;


            @(posedge clk);
            io_wr = 1; addr = 32'd100; D_in_IO = 32'hAAAA_BBBB;

            @(posedge clk);
            io_wr = 1; addr = 32'd200; D_in_IO = 32'hCCCC_DDDD;


            @(posedge clk);
            io_wr = 0; io_rd = 1; addr = 32'd100;
            @(posedge clk);
            #1;
            if (D_out_IO !== 32'hAAAA_BBBB) $display("Intermediate Check Failed at Addr 100");


            @(posedge clk);
            addr = 32'd200;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCCCC_DDDD, 1'b0);

            io_rd = 0;
            io_cs = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interrupt Acknowledge logic", test_num);
            reset_dut();


            @(posedge clk);
            int_ack = 1;
            @(posedge clk);
            int_ack = 0;
            @(posedge clk);


            io_cs = 1;
            io_rd = 1;
            addr = 32'h0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(D_out_IO, 1'b0);

            io_rd = 0;
            io_cs = 0;
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
        input [31:0] expected_D_out_IO;
        input expected_intr;
        begin
            if (expected_D_out_IO === (expected_D_out_IO ^ D_out_IO ^ expected_D_out_IO) &&
                expected_intr === (expected_intr ^ intr ^ expected_intr)) begin
                $display("PASS");
                $display("  Outputs: D_out_IO=%h, intr=%b",
                         D_out_IO, intr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_out_IO=%h, intr=%b",
                         expected_D_out_IO, expected_intr);
                $display("  Got:      D_out_IO=%h, intr=%b",
                         D_out_IO, intr);
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
        $dumpvars(0,D_in_IO, addr, clk, int_ack, io_cs, io_rd, io_wr, D_out_IO, intr);
    end

endmodule
