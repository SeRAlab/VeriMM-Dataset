`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] ram_radr;
    reg [7:0] ram_wadr;
    reg [7:0] ram_wdata;
    reg ram_wen;
    wire [7:0] ram_rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ram_radr(ram_radr),
        .ram_wadr(ram_wadr),
        .ram_wdata(ram_wdata),
        .ram_wen(ram_wen),
        .ram_rdata(ram_rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        ram_wen <= 0;
        ram_wadr <= 0;
        ram_wdata <= 0;
        ram_radr <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %03d: Basic Write and Read", test_num);


        ram_wen <= 1;
        ram_wadr <= 8'h05;
        ram_wdata <= 8'hAA;
        @(posedge clk);
        #1;


        ram_wen <= 0;
        ram_radr <= 8'h05;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %03d: Write Enable Check (should not write when wen=0)", test_num);


        ram_wen <= 0;
        ram_wadr <= 8'h10;
        ram_wdata <= 8'h55;
        @(posedge clk);
        #1;


        ram_radr <= 8'h10;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %03d: Concurrent Read and Write", test_num);


        ram_wen <= 1;
        ram_wadr <= 8'h20;
        ram_wdata <= 8'hCC;
        @(posedge clk);
        #1;


        ram_radr <= 8'h20;
        ram_wadr <= 8'h21;
        ram_wdata <= 8'hDD;
        ram_wen <= 1;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %03d: Boundary Address (0xFF)", test_num);

        ram_wen <= 1;
        ram_wadr <= 8'hFF;
        ram_wdata <= 8'h77;
        @(posedge clk);
        #1;

        ram_radr <= 8'hFF;
        ram_wen <= 0;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h77);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %03d: Multiple Writes Persistence", test_num);


        ram_wen <= 1;
        ram_wadr <= 8'h01; ram_wdata <= 8'h11; @(posedge clk); #1;
        ram_wadr <= 8'h02; ram_wdata <= 8'h22; @(posedge clk); #1;
        ram_wadr <= 8'h03; ram_wdata <= 8'h33; @(posedge clk); #1;

        ram_wen <= 0;
        ram_radr <= 8'h02;
        @(posedge clk);
        #2;

        #1;


        check_outputs(8'h22);
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
        input [7:0] expected_ram_rdata;
        begin
            if (expected_ram_rdata === (expected_ram_rdata ^ ram_rdata ^ expected_ram_rdata)) begin
                $display("PASS");
                $display("  Outputs: ram_rdata=%h",
                         ram_rdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_rdata=%h",
                         expected_ram_rdata);
                $display("  Got:      ram_rdata=%h",
                         ram_rdata);
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
        $dumpvars(0,clk, ram_radr, ram_wadr, ram_wdata, ram_wen, ram_rdata);
    end

endmodule
