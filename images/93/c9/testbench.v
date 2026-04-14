`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] addr;
    reg clrn;
    reg [31:0] datain;
    reg io_clk;
    reg write_io_enable;
    wire [31:0] out_port0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clrn(clrn),
        .datain(datain),
        .io_clk(io_clk),
        .write_io_enable(write_io_enable),
        .out_port0(out_port0)
    );

    // Clock generation (10ns period)
    initial begin
        clrn = 0;
        forever #5 clrn = ~clrn;
    end

        task reset_dut;

        begin
            clrn = 0;
            addr = 32'h0;
            datain = 32'h0;
            write_io_enable = 0;
            #15;
            clrn = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power-on Reset check", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successful write at valid address (0x20)", test_num);
            reset_dut();

            @(negedge io_clk);
            addr = 32'h00000020;
            datain = 32'hABCDEF01;
            write_io_enable = 1;

            @(posedge io_clk);
            #2;
            #1;

            check_outputs(32'hABCDEF01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write attempt with incorrect address", test_num);
            reset_dut();

            @(negedge io_clk);
            addr = 32'h00000021;
            datain = 32'hFFFFFFFF;
            write_io_enable = 1;

            @(posedge io_clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write attempt with write_enable low", test_num);
            reset_dut();

            @(negedge io_clk);
            addr = 32'h00000020;
            datain = 32'h5555AAAA;
            write_io_enable = 0;

            @(posedge io_clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple successive writes", test_num);
            reset_dut();


            @(negedge io_clk);
            addr = 32'h20; datain = 32'h11111111; write_io_enable = 1;
            @(posedge io_clk);


            @(negedge io_clk);
            addr = 32'h20; datain = 32'h22222222; write_io_enable = 1;
            @(posedge io_clk);

            #2;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-operation Asynchronous Clear", test_num);
            reset_dut();


            @(negedge io_clk);
            addr = 32'h20; datain = 32'hDEADBEEF; write_io_enable = 1;
            @(posedge io_clk);
            #2;


            #3;
            clrn = 0;
            #1;
            #1;

            check_outputs(32'h00000000);
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
        input [31:0] expected_out_port0;
        begin
            if (expected_out_port0 === (expected_out_port0 ^ out_port0 ^ expected_out_port0)) begin
                $display("PASS");
                $display("  Outputs: out_port0=%h",
                         out_port0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_port0=%h",
                         expected_out_port0);
                $display("  Got:      out_port0=%h",
                         out_port0);
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
        $dumpvars(0,addr, clrn, datain, io_clk, write_io_enable, out_port0);
    end

endmodule
