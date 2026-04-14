`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
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
            test_num = test_num + 1;
            reset_dut();


            addr = 10'd10;
            datain = 32'hDEADBEEF;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            $display("Testcase 001: Write/Read address 10");
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            addr = 10'd1023;
            datain = 32'h5555AAAA;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            $display("Testcase 002: Write/Read address 1023 (Boundary)");
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            addr = 10'd50;
            datain = 32'h11111111;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            datain = 32'h99999999;
            @(posedge clk);
            #1;


            @(posedge clk);
            #1;

            $display("Testcase 003: Verify Write Enable signal (should not overwrite)");
            #1;

            check_outputs(32'h11111111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            addr = 10'd100;
            datain = 32'hCAFEBABE;
            we = 1;
            @(posedge clk);
            #1;


            addr = 10'd200;
            datain = 32'h12345678;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            addr = 10'd100;
            @(posedge clk);
            #1;

            $display("Testcase 004: Check data persistence across multiple writes");
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
