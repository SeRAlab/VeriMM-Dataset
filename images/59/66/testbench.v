`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] r_addr1;
    reg [4:0] r_addr2;
    reg [4:0] w_addr;
    reg [31:0] w_data;
    reg we;
    wire [31:0] r_data1;
    wire [31:0] r_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .r_addr1(r_addr1),
        .r_addr2(r_addr2),
        .w_addr(w_addr),
        .w_data(w_data),
        .we(we),
        .r_data1(r_data1),
        .r_data2(r_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            r_addr1 = 0;
            r_addr2 = 0;
            w_addr = 0;
            w_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Testing Register 0 Hardwired logic...", test_num);
            we = 1;
            w_addr = 5'd0;
            w_data = 32'hFFFFFFFF;
            @(posedge clk);
            #1;
            we = 0;
            r_addr1 = 5'd0;
            r_addr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Testing basic Write and Read on Reg 5...", test_num);
            we = 1;
            w_addr = 5'd5;
            w_data = 32'hDEADBEEF;
            @(posedge clk);
            #1;
            we = 0;
            r_addr1 = 5'd5;
            r_addr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Testing Write Enable (we=0 should prevent write)...", test_num);

            we = 1; w_addr = 5'd10; w_data = 32'h11111111;
            @(posedge clk); #1;

            we = 0; w_addr = 5'd10; w_data = 32'hEEEEEEEE;
            @(posedge clk); #1;
            r_addr1 = 5'd10;
            r_addr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h11111111, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Testing dual port read (Reg 12 and Reg 24)...", test_num);

            we = 1; w_addr = 5'd12; w_data = 32'hAAAA5555;
            @(posedge clk); #1;

            we = 1; w_addr = 5'd24; w_data = 32'h5555AAAA;
            @(posedge clk); #1;
            we = 0;
            r_addr1 = 5'd12;
            r_addr2 = 5'd24;
            #1;
            #1;

            check_outputs(32'hAAAA5555, 32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Testing register overwrite...", test_num);
            we = 1; w_addr = 5'd7; w_data = 32'h00000001;
            @(posedge clk); #1;
            we = 1; w_addr = 5'd7; w_data = 32'h80000000;
            @(posedge clk); #1;
            we = 0; r_addr1 = 5'd7; r_addr2 = 5'd7;
            #1;
            #1;

            check_outputs(32'h80000000, 32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            $display("Test %0d: Testing boundary Register 31...", test_num);
            we = 1; w_addr = 5'd31; w_data = 32'hFFFFFFFF;
            @(posedge clk); #1;
            we = 0; r_addr1 = 5'd31; r_addr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h0);
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
        input [31:0] expected_r_data1;
        input [31:0] expected_r_data2;
        begin
            if (expected_r_data1 === (expected_r_data1 ^ r_data1 ^ expected_r_data1) &&
                expected_r_data2 === (expected_r_data2 ^ r_data2 ^ expected_r_data2)) begin
                $display("PASS");
                $display("  Outputs: r_data1=%h, r_data2=%h",
                         r_data1, r_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data1=%h, r_data2=%h",
                         expected_r_data1, expected_r_data2);
                $display("  Got:      r_data1=%h, r_data2=%h",
                         r_data1, r_data2);
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
        $dumpvars(0,clk, r_addr1, r_addr2, w_addr, w_data, we, r_data1, r_data2);
    end

endmodule
