`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] raddr;
    reg [9:0] waddr;
    reg [15:0] wdata;
    reg we;
    wire [15:0] rdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr(raddr),
        .waddr(waddr),
        .wdata(wdata),
        .we(we),
        .rdata(rdata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            waddr = 0;
            raddr = 0;
            wdata = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Write and Read at Address 0", test_num);
            reset_dut();


            we = 1;
            waddr = 10'd0;
            wdata = 16'hABCD;
            @(posedge clk);
            #1;


            we = 0;
            raddr = 10'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write/Read at Maximum Address 1023", test_num);
            reset_dut();


            we = 1;
            waddr = 10'd1023;
            wdata = 16'hFFFF;
            @(posedge clk);
            #1;


            we = 0;
            raddr = 10'd1023;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verify Write Enable functionality", test_num);
            reset_dut();


            we = 1; waddr = 10'd50; wdata = 16'h5555;
            @(posedge clk);
            #1;


            we = 0; waddr = 10'd50; wdata = 16'hAAAA;
            @(posedge clk);
            #1;


            raddr = 10'd50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous Read/Write at Different Addresses", test_num);
            reset_dut();


            we = 1; waddr = 10'd200; wdata = 16'h2222;
            @(posedge clk);
            #1;


            we = 1;
            waddr = 10'd100;
            wdata = 16'h1111;
            raddr = 10'd200;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data Integrity Pattern Test", test_num);
            reset_dut();


            we = 1; waddr = 10'd777; wdata = 16'hA5A5;
            @(posedge clk);
            #1;


            we = 0; raddr = 10'd777;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hA5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Persistence over multiple addresses", test_num);
            reset_dut();


            we = 1; waddr = 10'd10; wdata = 16'h1111;
            @(posedge clk);
            #1;

            we = 1; waddr = 10'd20; wdata = 16'h2222;
            @(posedge clk);
            #1;


            we = 0; raddr = 10'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h1111);
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
        input [15:0] expected_rdata;
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
        $dumpvars(0,clk, raddr, waddr, wdata, we, rdata);
    end

endmodule
