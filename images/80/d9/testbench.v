`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] raddr1;
    reg [5:0] raddr2;
    reg [5:0] waddr;
    reg [31:0] wdata;
    reg wen;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wen = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Basic Write and Dual Read", test_num);
            reset_dut();


            @(posedge clk);
            wen = 1;
            waddr = 6'd5;
            wdata = 32'h12345678;

            @(posedge clk);
            wen = 0;


            raddr1 = 6'd5;
            raddr2 = 6'd5;

            #2;
            #1;

            check_outputs(32'h12345678, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Write Enable (wen) Verification", test_num);
            reset_dut();


            @(posedge clk);
            wen = 1;
            waddr = 6'd10;
            wdata = 32'hAAAA_AAAA;
            @(posedge clk);


            wen = 0;
            waddr = 6'd10;
            wdata = 32'hBBBB_BBBB;
            @(posedge clk);


            raddr1 = 6'd10;
            raddr2 = 6'd0;

            #2;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Simultaneous Read from Two Different Addresses", test_num);
            reset_dut();


            @(posedge clk);
            wen = 1; waddr = 6'd20; wdata = 32'h20202020;
            @(posedge clk);


            wen = 1; waddr = 6'd30; wdata = 32'h30303030;
            @(posedge clk);
            wen = 0;


            raddr1 = 6'd20;
            raddr2 = 6'd30;

            #2;
            #1;

            check_outputs(32'h20202020, 32'h30303030);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Boundary Address Check (0 and 63)", test_num);
            reset_dut();


            @(posedge clk);
            wen = 1; waddr = 6'd0; wdata = 32'h0000_0001;
            @(posedge clk);


            wen = 1; waddr = 6'd63; wdata = 32'hFFFF_FFFE;
            @(posedge clk);
            wen = 0;

            raddr1 = 6'd0;
            raddr2 = 6'd63;

            #2;
            #1;

            check_outputs(32'h0000_0001, 32'hFFFF_FFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Data Overwrite Persistence", test_num);
            reset_dut();


            @(posedge clk);
            wen = 1; waddr = 6'd15; wdata = 32'h1111_1111;
            @(posedge clk);


            wen = 1; waddr = 6'd15; wdata = 32'h2222_2222;
            @(posedge clk);
            wen = 0;

            raddr1 = 6'd15;
            raddr2 = 6'd15;

            #2;
            #1;

            check_outputs(32'h2222_2222, 32'h2222_2222);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, raddr1, raddr2, waddr, wdata, wen, rdata1, rdata2);
    end

endmodule
