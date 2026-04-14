`timescale 1ns/1ps

module VirtualMemoryManagement_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] offset;
    reg [1:0] page_num;
    reg rst;
    wire [7:0] physical_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    VirtualMemoryManagement dut (
        .clk(clk),
        .offset(offset),
        .page_num(page_num),
        .rst(rst),
        .physical_addr(physical_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        page_num = 0;
        offset = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Page 0, Offset 5", test_num);
        reset_dut();
        page_num = 2'b00;
        offset = 4'h5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Page 1, Offset A", test_num);
        reset_dut();
        page_num = 2'b01;
        offset = 4'hA;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h1A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Page 2, Offset 0", test_num);
        reset_dut();
        page_num = 2'b10;
        offset = 4'h0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Page 3, Offset F", test_num);
        reset_dut();
        page_num = 2'b11;
        offset = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset Behavior", test_num);
        rst = 1;
        page_num = 2'b11;
        offset = 4'hF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00);
        rst = 0;
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("VirtualMemoryManagement Testbench");
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
        input [7:0] expected_physical_addr;
        begin
            if (expected_physical_addr === (expected_physical_addr ^ physical_addr ^ expected_physical_addr)) begin
                $display("PASS");
                $display("  Outputs: physical_addr=%h",
                         physical_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: physical_addr=%h",
                         expected_physical_addr);
                $display("  Got:      physical_addr=%h",
                         physical_addr);
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
        $dumpvars(0,clk, offset, page_num, rst, physical_addr);
    end

endmodule
