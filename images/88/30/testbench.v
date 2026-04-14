`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg rf_write;
    reg rst;
    reg [4:0] waddr;
    wire [31:0] rd_data1;
    wire [31:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data(data),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rf_write(rf_write),
        .rst(rst),
        .waddr(waddr),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            rf_write = 0;
            waddr = 0;
            data = 0;
            raddr1 = 0;
            raddr2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Post-reset zero check", test_num);
            reset_dut();

            raddr1 = 5'd1;
            raddr2 = 5'd2;
            #2;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic write to R5 and read back", test_num);
            reset_dut();


            @(negedge clk);
            rf_write = 1;
            waddr = 5'd5;
            data = 32'hABCD1234;
            @(posedge clk);
            #1 rf_write = 0;


            raddr1 = 5'd5;
            raddr2 = 5'd5;
            #2;

            #1;


            check_outputs(32'hABCD1234, 32'hABCD1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Dual register read (R10 and R20)", test_num);
            reset_dut();


            @(negedge clk);
            rf_write = 1;
            waddr = 5'd10;
            data = 32'h11112222;
            @(posedge clk);


            waddr = 5'd20;
            data = 32'hAAAA5555;
            @(posedge clk);
            #1 rf_write = 0;


            raddr1 = 5'd10;
            raddr2 = 5'd20;
            #2;

            #1;


            check_outputs(32'h11112222, 32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overwrite register R15", test_num);
            reset_dut();


            @(negedge clk);
            rf_write = 1;
            waddr = 5'd15;
            data = 32'hDEAFBEEF;
            @(posedge clk);


            data = 32'hCAFEBABE;
            @(posedge clk);
            #1 rf_write = 0;

            raddr1 = 5'd15;
            raddr2 = 5'd0;
            #2;

            #1;


            check_outputs(32'hCAFEBABE, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary address check (R0 and R31)", test_num);
            reset_dut();


            @(negedge clk);
            rf_write = 1;
            waddr = 5'd31;
            data = 32'hFFFFFFFF;
            @(posedge clk);





            waddr = 5'd0;
            data = 32'h12345678;
            @(posedge clk);
            #1 rf_write = 0;

            raddr1 = 5'd31;
            raddr2 = 5'd0;
            #2;



            #1;




            check_outputs(32'hFFFFFFFF, 32'h12345678);
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
        input [31:0] expected_rd_data1;
        input [31:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clk, data, raddr1, raddr2, rf_write, rst, waddr, rd_data1, rd_data2);
    end

endmodule
