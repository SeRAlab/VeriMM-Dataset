`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg [4:0] rdaddress;
    reg [4:0] wraddress;
    reg wren;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wren = 0;
            data = 0;
            rdaddress = 0;
            wraddress = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(negedge clk);
            wren = 1;
            wraddress = 5;
            data = 32'h12345678;

            @(negedge clk);
            wren = 0;
            rdaddress = 5;

            @(negedge clk);
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes", test_num);
            reset_dut();


            @(negedge clk);
            wren = 1;
            wraddress = 0;
            data = 32'hAAAAAAAA;


            @(negedge clk);
            wraddress = 31;
            data = 32'h55555555;

            @(negedge clk);
            wren = 0;
            rdaddress = 0;

            @(negedge clk);

            if (q !== 32'hAAAAAAAA) begin
                $display("Error at Addr 0");
            end

            rdaddress = 31;
            @(negedge clk);

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();


            @(negedge clk);
            wren = 0;
            wraddress = 10;
            data = 32'hFFFFFFFF;

            @(negedge clk);
            rdaddress = 10;

            @(negedge clk);

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();


            @(negedge clk);
            wren = 1;
            wraddress = 15;
            data = 32'hBEEFCAFE;


            @(negedge clk);
            data = 32'hDEADBEEF;

            @(negedge clk);
            wren = 0;
            rdaddress = 15;

            @(negedge clk);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();


            @(negedge clk);
            wren = 1;
            wraddress = 1;
            data = 32'h11111111;


            @(negedge clk);
            wraddress = 2;
            data = 32'h22222222;
            rdaddress = 1;

            @(negedge clk);

            #1;


            check_outputs(32'h11111111);
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
        input [31:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, data, rdaddress, wraddress, wren, q);
    end

endmodule
