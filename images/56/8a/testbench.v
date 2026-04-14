`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] ex_hi;
    reg [4:0] ex_lo;
    reg [4:0] ex_waddr;
    reg [31:0] ex_wdata;
    reg ex_we;
    reg ex_whilo;
    reg reset_n;
    wire [4:0] mem_hi;
    wire [31:0] mem_lo;
    wire [4:0] mem_waddr;
    wire [31:0] mem_wdata;
    wire mem_we;
    wire mem_whilo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ex_hi(ex_hi),
        .ex_lo(ex_lo),
        .ex_waddr(ex_waddr),
        .ex_wdata(ex_wdata),
        .ex_we(ex_we),
        .ex_whilo(ex_whilo),
        .reset_n(reset_n),
        .mem_hi(mem_hi),
        .mem_lo(mem_lo),
        .mem_waddr(mem_waddr),
        .mem_wdata(mem_wdata),
        .mem_we(mem_we),
        .mem_whilo(mem_whilo)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            ex_hi = 0;
            ex_lo = 0;
            ex_waddr = 0;
            ex_wdata = 0;
            ex_we = 0;
            ex_whilo = 0;
            @(posedge clk);
            #2;
            reset_n = 1;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Functionality", test_num);
            reset_n = 0;
            #15;

            #1;


            check_outputs(5'h0, 32'h0, 5'h0, 32'h0, 1'b0, 1'b0);
            reset_n = 1;
            @(posedge clk);
            #2;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Propagation", test_num);
            reset_dut();


            ex_we = 1'b1;
            ex_waddr = 5'h1A;
            ex_wdata = 32'hDEADBEEF;
            ex_whilo = 1'b0;
            ex_hi = 5'h05;
            ex_lo = 5'h0A;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h05, 32'h0A, 5'h1A, 32'hDEADBEEF, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagation with whilo Active", test_num);
            reset_dut();


            ex_we = 1'b1;
            ex_waddr = 5'h0F;
            ex_wdata = 32'h12345678;
            ex_whilo = 1'b1;
            ex_hi = 5'h1F;
            ex_lo = 5'h00;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F, 32'h00, 5'h0F, 32'h12345678, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Low Propagation", test_num);
            reset_dut();


            ex_we = 1'b0;
            ex_waddr = 5'h01;
            ex_wdata = 32'hAAAA_BBBB;
            ex_whilo = 1'b0;
            ex_hi = 5'h10;
            ex_lo = 5'h11;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h10, 32'h11, 5'h01, 32'hAAAA_BBBB, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Values (All Ones)", test_num);
            reset_dut();

            ex_we = 1'b1;
            ex_waddr = 5'h1F;
            ex_wdata = 32'hFFFF_FFFF;
            ex_whilo = 1'b1;
            ex_hi = 5'h1F;
            ex_lo = 5'h1F;

            @(posedge clk);
            #2;

            #1;


            check_outputs(5'h1F, 32'h1F, 5'h1F, 32'hFFFF_FFFF, 1'b1, 1'b1);
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
        input [4:0] expected_mem_hi;
        input [31:0] expected_mem_lo;
        input [4:0] expected_mem_waddr;
        input [31:0] expected_mem_wdata;
        input expected_mem_we;
        input expected_mem_whilo;
        begin
            if (expected_mem_hi === (expected_mem_hi ^ mem_hi ^ expected_mem_hi) &&
                expected_mem_lo === (expected_mem_lo ^ mem_lo ^ expected_mem_lo) &&
                expected_mem_waddr === (expected_mem_waddr ^ mem_waddr ^ expected_mem_waddr) &&
                expected_mem_wdata === (expected_mem_wdata ^ mem_wdata ^ expected_mem_wdata) &&
                expected_mem_we === (expected_mem_we ^ mem_we ^ expected_mem_we) &&
                expected_mem_whilo === (expected_mem_whilo ^ mem_whilo ^ expected_mem_whilo)) begin
                $display("PASS");
                $display("  Outputs: mem_hi=%h, mem_lo=%h, mem_waddr=%h, mem_wdata=%h, mem_we=%b, mem_whilo=%b",
                         mem_hi, mem_lo, mem_waddr, mem_wdata, mem_we, mem_whilo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_hi=%h, mem_lo=%h, mem_waddr=%h, mem_wdata=%h, mem_we=%b, mem_whilo=%b",
                         expected_mem_hi, expected_mem_lo, expected_mem_waddr, expected_mem_wdata, expected_mem_we, expected_mem_whilo);
                $display("  Got:      mem_hi=%h, mem_lo=%h, mem_waddr=%h, mem_wdata=%h, mem_we=%b, mem_whilo=%b",
                         mem_hi, mem_lo, mem_waddr, mem_wdata, mem_we, mem_whilo);
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
        $dumpvars(0,clk, ex_hi, ex_lo, ex_waddr, ex_wdata, ex_we, ex_whilo, reset_n, mem_hi, mem_lo, mem_waddr, mem_wdata, mem_we, mem_whilo);
    end

endmodule
