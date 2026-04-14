`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [31:0] datain;
    reg reset;
    reg write;
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
        .reset(reset),
        .write(write),
        .dataout(dataout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write = 0;
            addr = 0;
            datain = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            addr = 16'h000A;
            datain = 32'hA5A5A5A5;
            write = 1;
            @(posedge clk);
            #1 write = 0;


            #1;



            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Boundary Write Address 0", test_num);
            reset_dut();

            addr = 16'h0000;
            datain = 32'h12345678;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Boundary Write Address 255", test_num);
            reset_dut();

            addr = 16'h00FF;
            datain = 32'h87654321;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            #1;


            check_outputs(32'h87654321);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();


            addr = 16'h0020;
            datain = 32'hBBBBBBBB;
            write = 1;
            @(posedge clk);
            #1 write = 0;


            datain = 32'hCCCCCCCC;
            write = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'hBBBBBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwrite existing data", test_num);
            reset_dut();


            addr = 16'h0040;
            datain = 32'h11111111;
            write = 1;
            @(posedge clk);
            #1;


            datain = 32'h22222222;
            write = 1;
            @(posedge clk);
            #1 write = 0;

            #1;


            check_outputs(32'h22222222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Sequential Read after Multiple Writes", test_num);
            reset_dut();


            addr = 16'h0010;
            datain = 32'hD1;
            write = 1;
            @(posedge clk);


            addr = 16'h0020;
            datain = 32'hD2;
            write = 1;
            @(posedge clk);
            #1 write = 0;


            addr = 16'h0010;
            #1;
            #1;

            check_outputs(32'hD1);
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
        $dumpvars(0,addr, clk, datain, reset, write, dataout);
    end

endmodule
