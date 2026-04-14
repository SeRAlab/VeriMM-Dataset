`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] m_addr;
    reg [31:0] m_din;
    reg m_read;
    reg m_write;
    reg rst;
    wire [31:0] m_dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .m_addr(m_addr),
        .m_din(m_din),
        .m_read(m_read),
        .m_write(m_write),
        .rst(rst),
        .m_dout(m_dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            m_read = 0;
            m_write = 0;
            m_addr = 0;
            m_din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            m_addr = 32'h0000_000A;
            m_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            m_addr = 32'h0000_0005;
            m_din = 32'hDEADBEEF;
            m_write = 1;
            @(posedge clk);
            #1 m_write = 0;


            m_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Address Masking Check", test_num);
            reset_dut();


            m_addr = 32'hFFFF_FC01;
            m_din = 32'hCAFEBABE;
            m_write = 1;
            @(posedge clk);
            #1 m_write = 0;


            m_addr = 32'h0000_0001;
            m_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwrite Check", test_num);
            reset_dut();


            m_addr = 32'h0000_0020;
            m_din = 32'h1111_1111;
            m_write = 1;
            @(posedge clk);
            #1;


            m_din = 32'h2222_2222;
            @(posedge clk);
            #1 m_write = 0;


            m_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h2222_2222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Write Enable Low Check", test_num);
            reset_dut();

            m_addr = 32'h0000_0030;
            m_din = 32'h5555_5555;
            m_write = 0;
            @(posedge clk);
            #1;

            m_read = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
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
        input [31:0] expected_m_dout;
        begin
            if (expected_m_dout === (expected_m_dout ^ m_dout ^ expected_m_dout)) begin
                $display("PASS");
                $display("  Outputs: m_dout=%h",
                         m_dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: m_dout=%h",
                         expected_m_dout);
                $display("  Got:      m_dout=%h",
                         m_dout);
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
        $dumpvars(0,clk, m_addr, m_din, m_read, m_write, rst, m_dout);
    end

endmodule
