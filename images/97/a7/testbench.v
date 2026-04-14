`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] Mem_Addr;
    reg [31:0] Mem_DIN;
    reg Mem_rd;
    reg Mem_wr;
    wire [31:0] Mem_DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .Mem_Addr(Mem_Addr),
        .Mem_DIN(Mem_DIN),
        .Mem_rd(Mem_rd),
        .Mem_wr(Mem_wr),
        .Mem_DOUT(Mem_DOUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            Mem_Addr = 0;
            Mem_DIN = 0;
            Mem_rd = 0;
            Mem_wr = 0;
            repeat (2) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            @(negedge CLK);
            Mem_Addr = 32'd0;
            Mem_DIN = 32'hA5A5A5A5;
            Mem_wr = 1;
            @(negedge CLK);
            Mem_wr = 0;


            #10;
            Mem_rd = 1;
            Mem_Addr = 32'd0;
            #20;

            #1;


            check_outputs(32'hA5A5A5A5);
            Mem_rd = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write and Read at max Address 1023");
            reset_dut();


            @(negedge CLK);
            Mem_Addr = 32'd1023;
            Mem_DIN = 32'h5A5A5A5A;
            Mem_wr = 1;
            @(negedge CLK);
            Mem_wr = 0;


            #10;
            Mem_rd = 1;
            Mem_Addr = 32'd1023;
            #20;

            #1;


            check_outputs(32'h5A5A5A5A);
            Mem_rd = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write to Addr 10 and 20, Read Addr 10");
            reset_dut();


            @(negedge CLK);
            Mem_Addr = 32'd10;
            Mem_DIN = 32'h11112222;
            Mem_wr = 1;
            @(negedge CLK);


            Mem_Addr = 32'd20;
            Mem_DIN = 32'h33334444;
            @(negedge CLK);
            Mem_wr = 0;


            #10;
            Mem_rd = 1;
            Mem_Addr = 32'd10;
            #20;

            #1;


            check_outputs(32'h11112222);
            Mem_rd = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Write to Addr 10 and 20, Read Addr 20");
            reset_dut();


            @(negedge CLK);
            Mem_Addr = 32'd10;
            Mem_DIN = 32'hDEADBEEF;
            Mem_wr = 1;
            @(negedge CLK);


            Mem_Addr = 32'd20;
            Mem_DIN = 32'hCAFEBABE;
            @(negedge CLK);
            Mem_wr = 0;


            #10;
            Mem_rd = 1;
            Mem_Addr = 32'd20;
            #20;

            #1;


            check_outputs(32'hCAFEBABE);
            Mem_rd = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting Address 500");
            reset_dut();


            @(negedge CLK);
            Mem_Addr = 32'd500;
            Mem_DIN = 32'h0000FFFF;
            Mem_wr = 1;
            @(negedge CLK);


            Mem_DIN = 32'hFFFF0000;
            @(negedge CLK);
            Mem_wr = 0;


            #10;
            Mem_rd = 1;
            Mem_Addr = 32'd500;
            #20;

            #1;


            check_outputs(32'hFFFF0000);
            Mem_rd = 0;
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
        input [31:0] expected_Mem_DOUT;
        begin
            if (expected_Mem_DOUT === (expected_Mem_DOUT ^ Mem_DOUT ^ expected_Mem_DOUT)) begin
                $display("PASS");
                $display("  Outputs: Mem_DOUT=%h",
                         Mem_DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Mem_DOUT=%h",
                         expected_Mem_DOUT);
                $display("  Got:      Mem_DOUT=%h",
                         Mem_DOUT);
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
        $dumpvars(0,CLK, Mem_Addr, Mem_DIN, Mem_rd, Mem_wr, Mem_DOUT);
    end

endmodule
