`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] mem_i_waddr;
    reg [31:0] mem_i_wdata;
    reg [31:0] mem_i_wdata_hi;
    reg [31:0] mem_i_wdata_lo;
    reg mem_i_we_hilo;
    reg mem_i_wreg;
    reg rst_;
    wire [4:0] mem_o_waddr;
    wire [31:0] mem_o_wdata;
    wire [31:0] mem_o_wdata_hi;
    wire [31:0] mem_o_wdata_lo;
    wire mem_o_we_hilo;
    wire mem_o_wreg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mem_i_waddr(mem_i_waddr),
        .mem_i_wdata(mem_i_wdata),
        .mem_i_wdata_hi(mem_i_wdata_hi),
        .mem_i_wdata_lo(mem_i_wdata_lo),
        .mem_i_we_hilo(mem_i_we_hilo),
        .mem_i_wreg(mem_i_wreg),
        .rst_(rst_),
        .mem_o_waddr(mem_o_waddr),
        .mem_o_wdata(mem_o_wdata),
        .mem_o_wdata_hi(mem_o_wdata_hi),
        .mem_o_wdata_lo(mem_o_wdata_lo),
        .mem_o_we_hilo(mem_o_we_hilo),
        .mem_o_wreg(mem_o_wreg)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Functionality (rst_ = 0)", test_num);


            rst_ = 1'b0;
            mem_i_waddr = 5'h1F;
            mem_i_wdata = 32'hFFFFFFFF;
            mem_i_wdata_hi = 32'hAAAAAAAA;
            mem_i_wdata_lo = 32'h55555555;
            mem_i_we_hilo = 1'b1;
            mem_i_wreg = 1'b1;


            #1;



            check_outputs(5'h00, 32'h0, 32'h0, 32'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Basic Register Write (rst_ = 1)", test_num);

            rst_ = 1'b1;
            mem_i_waddr = 5'h0A;
            mem_i_wdata = 32'h12345678;
            mem_i_wreg = 1'b1;

            mem_i_we_hilo = 1'b0;
            mem_i_wdata_hi = 32'h0;
            mem_i_wdata_lo = 32'h0;

            #1;


            check_outputs(5'h0A, 32'h12345678, 32'h0, 32'h0, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: HI/LO Register Write (rst_ = 1)", test_num);

            rst_ = 1'b1;
            mem_i_we_hilo = 1'b1;
            mem_i_wdata_hi = 32'hDEADC0DE;
            mem_i_wdata_lo = 32'hBEEFBABE;

            mem_i_waddr = 5'h0;
            mem_i_wdata = 32'h0;
            mem_i_wreg = 1'b0;

            #1;


            check_outputs(5'h0, 32'h0, 32'hDEADC0DE, 32'hBEEFBABE, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Simultaneous General and HI/LO Write", test_num);

            rst_ = 1'b1;
            mem_i_waddr = 5'h15;
            mem_i_wreg = 1'b1;
            mem_i_wdata = 32'hCAFEF00D;
            mem_i_we_hilo = 1'b1;
            mem_i_wdata_hi = 32'h11112222;
            mem_i_wdata_lo = 32'h33334444;

            #1;


            check_outputs(5'h15, 32'hCAFEF00D, 32'h11112222, 32'h33334444, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Write Signals with Enables Low", test_num);

            rst_ = 1'b1;
            mem_i_waddr = 5'h05;
            mem_i_wreg = 1'b0;
            mem_i_wdata = 32'h88889999;
            mem_i_we_hilo = 1'b0;
            mem_i_wdata_hi = 32'h12121212;
            mem_i_wdata_lo = 32'h34343434;

            #1;


            check_outputs(5'h05, 32'h88889999, 32'h12121212, 32'h34343434, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Boundary Values (Addr 31, All-Ones)", test_num);

            rst_ = 1'b1;
            mem_i_waddr = 5'd31;
            mem_i_wreg = 1'b1;
            mem_i_wdata = 32'hFFFFFFFF;
            mem_i_we_hilo = 1'b1;
            mem_i_wdata_hi = 32'hFFFFFFFF;
            mem_i_wdata_lo = 32'hFFFFFFFF;

            #1;


            check_outputs(5'd31, 32'hFFFFFFFF, 32'hFFFFFFFF, 32'hFFFFFFFF, 1'b1, 1'b1);
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
        input [4:0] expected_mem_o_waddr;
        input [31:0] expected_mem_o_wdata;
        input [31:0] expected_mem_o_wdata_hi;
        input [31:0] expected_mem_o_wdata_lo;
        input expected_mem_o_we_hilo;
        input expected_mem_o_wreg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mem_o_waddr === (expected_mem_o_waddr ^ mem_o_waddr ^ expected_mem_o_waddr) &&
                expected_mem_o_wdata === (expected_mem_o_wdata ^ mem_o_wdata ^ expected_mem_o_wdata) &&
                expected_mem_o_wdata_hi === (expected_mem_o_wdata_hi ^ mem_o_wdata_hi ^ expected_mem_o_wdata_hi) &&
                expected_mem_o_wdata_lo === (expected_mem_o_wdata_lo ^ mem_o_wdata_lo ^ expected_mem_o_wdata_lo) &&
                expected_mem_o_we_hilo === (expected_mem_o_we_hilo ^ mem_o_we_hilo ^ expected_mem_o_we_hilo) &&
                expected_mem_o_wreg === (expected_mem_o_wreg ^ mem_o_wreg ^ expected_mem_o_wreg)) begin
                $display("PASS");
                $display("  Outputs: mem_o_waddr=%h, mem_o_wdata=%h, mem_o_wdata_hi=%h, mem_o_wdata_lo=%h, mem_o_we_hilo=%b, mem_o_wreg=%b",
                         mem_o_waddr, mem_o_wdata, mem_o_wdata_hi, mem_o_wdata_lo, mem_o_we_hilo, mem_o_wreg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_o_waddr=%h, mem_o_wdata=%h, mem_o_wdata_hi=%h, mem_o_wdata_lo=%h, mem_o_we_hilo=%b, mem_o_wreg=%b",
                         expected_mem_o_waddr, expected_mem_o_wdata, expected_mem_o_wdata_hi, expected_mem_o_wdata_lo, expected_mem_o_we_hilo, expected_mem_o_wreg);
                $display("  Got:      mem_o_waddr=%h, mem_o_wdata=%h, mem_o_wdata_hi=%h, mem_o_wdata_lo=%h, mem_o_we_hilo=%b, mem_o_wreg=%b",
                         mem_o_waddr, mem_o_wdata, mem_o_wdata_hi, mem_o_wdata_lo, mem_o_we_hilo, mem_o_wreg);
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
