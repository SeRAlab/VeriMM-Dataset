`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] addr;
    reg clk;
    reg [31:0] datain;
    reg en;
    reg rst;
    reg [3:0] we;
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
        .en(en),
        .rst(rst),
        .we(we),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset functionality", test_num);
            rst = 1; en = 0; we = 0; addr = 0; datain = 0;
            @(posedge clk);
            #2;
            rst = 0;
            #1;

            check_outputs(32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read back at addr 0x0A", test_num);

            rst = 1; @(posedge clk); #2; rst = 0;

            en = 1; we = 4'hf; addr = 7'h0A; datain = 32'hDEADBEEF;
            @(posedge clk);
            #2;

            we = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary address (0x7F) check", test_num);

            rst = 1; @(posedge clk); #2; rst = 0;

            en = 1; we = 4'hf; addr = 7'h7F; datain = 32'hAAAA5555;
            @(posedge clk);
            #2;

            we = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Byte-mask write (we=4'b1001)", test_num);

            rst = 1; @(posedge clk); #2; rst = 0;

            en = 1; we = 4'hf; addr = 7'h20; datain = 32'h0;
            @(posedge clk);
            #2;

            we = 4'b1001; datain = 32'hFF1122EE;
            @(posedge clk);
            #2;

            we = 4'h0;
            @(posedge clk);
            #1;

            check_outputs(32'hFF0000EE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Disable RAM (en=0) check", test_num);

            rst = 1; @(posedge clk); #2; rst = 0;

            en = 0; we = 4'hf; addr = 7'h30; datain = 32'h12345678;
            @(posedge clk);
            #2;

            addr = 7'h30;
            @(posedge clk);
            #1;

            check_outputs(32'h0);
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
            #1; // Small delay for combinational logic to settle
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

endmodule
