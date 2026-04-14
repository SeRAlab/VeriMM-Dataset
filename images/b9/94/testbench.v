`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [31:0] datain;
    reg we;
    wire [31:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .datain(datain),
        .we(we),
        .dataout(dataout)
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
            datain = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Write 0x12345678 to Address 0");


            addr = 2'd0;
            datain = 32'h12345678;
            we = 1'b1;


            @(posedge clk);
            #2;


            we = 1'b0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Write 0xABCDEF00 to Address 1");


            addr = 2'd1;
            datain = 32'hABCDEF00;
            we = 1'b1;


            @(posedge clk);
            #2;

            we = 1'b0;
            #1;

            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Attempt write to Address 0 with WE=0");


            addr = 2'd0;
            datain = 32'h5555AAAA;
            we = 1'b1;
            @(posedge clk);
            #2;


            datain = 32'hFFFFFFFF;
            we = 1'b0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Write both blocks and switch address to read");


            addr = 2'd0;
            datain = 32'h00001111;
            we = 1'b1;
            @(posedge clk);
            #2;


            addr = 2'd1;
            datain = 32'h22223333;
            we = 1'b1;
            @(posedge clk);
            #2;


            we = 1'b0;
            addr = 2'd0;
            #1;

            #1;


            check_outputs(32'h00001111);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Verify writing Addr 1 doesn't affect Addr 0");


            addr = 2'd0;
            datain = 32'hDEADBEEF;
            we = 1'b1;
            @(posedge clk);
            #2;


            addr = 2'd1;
            datain = 32'hCAFEBABE;
            we = 1'b1;
            @(posedge clk);
            #2;


            we = 1'b0;
            addr = 2'd1;
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
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
        input [31:0] expected_dataout;
        begin
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
        $dumpvars(0,addr, clk, datain, we, dataout);
    end

endmodule
