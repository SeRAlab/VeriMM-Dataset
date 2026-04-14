`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [7:0] wdata;
    reg [3:0] wen;
    wire [7:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .wdata(wdata),
        .wen(wen),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            wdata = 0;
            wen = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write and Read Address 0", test_num);


            addr = 2'b00;
            wdata = 8'hA5;
            wen = 4'b0001;
            @(posedge clk);
            #2;


            wen = 4'b0000;
            addr = 2'b00;
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Write and Read Address 3", test_num);


            addr = 2'b11;
            wdata = 8'h5A;
            wen = 4'b1000;
            @(posedge clk);
            #2;


            wen = 4'b0000;
            addr = 2'b11;
            #2;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Data Isolation Check", test_num);


            addr = 2'b01;
            wdata = 8'h11;
            wen = 4'b0010;
            @(posedge clk);
            #2;


            addr = 2'b10;
            wdata = 8'h22;
            wen = 4'b0100;
            @(posedge clk);
            #2;


            wen = 4'b0000;
            addr = 2'b01;
            #2;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Disable Check", test_num);


            addr = 2'b00;
            wdata = 8'hFF;
            wen = 4'b0001;
            @(posedge clk);
            #2;


            addr = 2'b00;
            wdata = 8'h00;
            wen = 4'b0000;
            @(posedge clk);
            #2;


            addr = 2'b00;
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Sequential Read Check", test_num);


            addr = 0; wdata = 8'h10; wen = 4'b0001; @(posedge clk); #2;
            addr = 1; wdata = 8'h20; wen = 4'b0010; @(posedge clk); #2;
            addr = 2; wdata = 8'h30; wen = 4'b0100; @(posedge clk); #2;
            addr = 3; wdata = 8'h40; wen = 4'b1000; @(posedge clk); #2;


            wen = 0;
            addr = 2'b10;
            #2;
            #1;

            check_outputs(8'h30);
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
        input [7:0] expected_rdata;
        begin
            if (expected_rdata === (expected_rdata ^ rdata ^ expected_rdata)) begin
                $display("PASS");
                $display("  Outputs: rdata=%h",
                         rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata=%h",
                         expected_rdata);
                $display("  Got:      rdata=%h",
                         rdata);
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
        $dumpvars(0,addr, clk, wdata, wen, rdata);
    end

endmodule
