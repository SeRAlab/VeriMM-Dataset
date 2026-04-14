`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [8:0] cpu_addr;
    reg [31:0] cpu_wdata;
    reg cpu_wr_n;
    reg pRST;
    wire error;
    wire [15:0] flag_set;
    wire [23:0] length_set;
    wire [31:0] packet_head;
    wire scramble;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cpu_addr(cpu_addr),
        .cpu_wdata(cpu_wdata),
        .cpu_wr_n(cpu_wr_n),
        .pRST(pRST),
        .error(error),
        .flag_set(flag_set),
        .length_set(length_set),
        .packet_head(packet_head),
        .scramble(scramble)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pRST = 1;
            cpu_wr_n = 1;
            cpu_addr = 0;
            cpu_wdata = 0;
            repeat(2) @(posedge clk);
            #1 pRST = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(0, 16'h0, 24'h0, 32'h0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Packet Head (Addr 200)", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 9'd200;
            cpu_wdata = 32'hA5A5_5A5A;
            cpu_wr_n = 0;
            @(posedge clk);
            #1 cpu_wr_n = 1;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(0, 16'h0, 24'h0, 32'hA5A5_5A5A, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Flag Set (Addr 201)", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 9'd201;
            cpu_wdata = 32'h0000_FFFF;
            cpu_wr_n = 0;
            @(posedge clk);
            #1 cpu_wr_n = 1;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(0, 16'hFFFF, 24'h0, 32'h0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Length Set (Addr 202)", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 9'd202;
            cpu_wdata = 32'h00CC_BBAA;
            cpu_wr_n = 0;
            @(posedge clk);
            #1 cpu_wr_n = 1;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(0, 16'h0, 24'hCCBBAA, 32'h0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Scramble (Addr 203)", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 9'd203;
            cpu_wdata = 32'h0000_0001;
            cpu_wr_n = 0;
            @(posedge clk);
            #1 cpu_wr_n = 1;
            repeat(1) @(posedge clk);
            #1;

            check_outputs(0, 16'h0, 24'h0, 32'h0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Write All Registers", test_num);
            reset_dut();


            @(negedge clk);
            cpu_addr = 200; cpu_wdata = 32'h12345678; cpu_wr_n = 0;
            @(posedge clk);

            #1 cpu_addr = 201; cpu_wdata = 32'h0000_ABCD;
            @(posedge clk);

            #1 cpu_addr = 202; cpu_wdata = 32'h00112233;
            @(posedge clk);

            #1 cpu_addr = 203; cpu_wdata = 32'h0000_0001;
            @(posedge clk);
            #1 cpu_wr_n = 1;

            repeat(1) @(posedge clk);
            #1;

            check_outputs(0, 16'hABCD, 24'h112233, 32'h12345678, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Inhibition", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 200;
            cpu_wdata = 32'hFFFF_FFFF;
            cpu_wr_n = 1;
            @(posedge clk);
            repeat(1) @(posedge clk);

            #1;


            check_outputs(0, 16'h0, 24'h0, 32'h0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Out of Range Address (Error Test)", test_num);
            reset_dut();
            @(negedge clk);
            cpu_addr = 9'd210;
            cpu_wdata = 32'hFFFF_FFFF;
            cpu_wr_n = 0;
            @(posedge clk);
            #1 cpu_wr_n = 1;
            repeat(1) @(posedge clk);


            if (packet_head == 0 && flag_set == 0 && length_set == 0 && scramble == 0) begin
                 pass_count = pass_count + 1;
                 $display("PASS: No registers corrupted by out-of-range write.");
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Registers corrupted by out-of-range write.");
            end
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
        testcase007();
        testcase008();
        
        
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
        input expected_error;
        input [15:0] expected_flag_set;
        input [23:0] expected_length_set;
        input [31:0] expected_packet_head;
        input expected_scramble;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_flag_set === (expected_flag_set ^ flag_set ^ expected_flag_set) &&
                expected_length_set === (expected_length_set ^ length_set ^ expected_length_set) &&
                expected_packet_head === (expected_packet_head ^ packet_head ^ expected_packet_head) &&
                expected_scramble === (expected_scramble ^ scramble ^ expected_scramble)) begin
                $display("PASS");
                $display("  Outputs: error=%b, flag_set=%h, length_set=%h, packet_head=%h, scramble=%b",
                         error, flag_set, length_set, packet_head, scramble);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, flag_set=%h, length_set=%h, packet_head=%h, scramble=%b",
                         expected_error, expected_flag_set, expected_length_set, expected_packet_head, expected_scramble);
                $display("  Got:      error=%b, flag_set=%h, length_set=%h, packet_head=%h, scramble=%b",
                         error, flag_set, length_set, packet_head, scramble);
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
        $dumpvars(0,clk, cpu_addr, cpu_wdata, cpu_wr_n, pRST, error, flag_set, length_set, packet_head, scramble);
    end

endmodule
