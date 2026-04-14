`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] rd1addr;
    reg rd1en;
    reg [4:0] rd2addr;
    reg rd2en;
    reg [15:0] wbyteen;
    reg [4:0] wraddr;
    reg [127:0] wrdata;
    reg wren;
    wire [127:0] rd1data;
    wire [127:0] rd2data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd1addr(rd1addr),
        .rd1en(rd1en),
        .rd2addr(rd2addr),
        .rd2en(rd2en),
        .wbyteen(wbyteen),
        .wraddr(wraddr),
        .wrdata(wrdata),
        .wren(wren),
        .rd1data(rd1data),
        .rd2data(rd2data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rd1addr = 0; rd1en = 0;
            rd2addr = 0; rd2en = 0;
            wraddr = 0; wrdata = 0;
            wren = 0; wbyteen = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            @(negedge clk);
            wren = 1;
            wraddr = 5'd1;
            wrdata = 128'h0123456789ABCDEF0123456789ABCDEF;
            wbyteen = 16'hFFFF;
            @(negedge clk);
            wren = 0;


            rd1en = 1; rd1addr = 5'd1;
            rd2en = 1; rd2addr = 5'd1;

            #1;


            check_outputs(128'h0123456789ABCDEF0123456789ABCDEF, 128'h0123456789ABCDEF0123456789ABCDEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            @(negedge clk);
            wren = 1; wraddr = 5'd2;
            wrdata = 128'hFEDCBA9876543210FEDCBA9876543210;
            wbyteen = 16'hFFFF;
            @(negedge clk);
            wren = 0;


            rd1en = 0; rd1addr = 5'd2;
            rd2en = 1; rd2addr = 5'd2;

            #1;


            check_outputs(128'h0, 128'hFEDCBA9876543210FEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            @(negedge clk);
            wren = 1; wraddr = 5'd3;
            wrdata = {128{1'b1}};
            wbyteen = 16'hFFFF;
            @(negedge clk);

            wrdata = 128'h0;
            wbyteen = 16'h00FF;
            @(negedge clk);
            wren = 0;

            rd1en = 1; rd1addr = 5'd3;
            rd2en = 0;


            #1;



            check_outputs(128'hFFFFFFFFFFFFFFFF0000000000000000, 128'h0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(negedge clk);
            wren = 1; wraddr = 5'd0; wrdata = 128'hAAAA_AAAA_AAAA_AAAA_BBBB_BBBB_BBBB_BBBB; wbyteen = 16'hFFFF;
            @(negedge clk);

            wraddr = 5'd31; wrdata = 128'hCCCC_CCCC_CCCC_CCCC_DDDD_DDDD_DDDD_DDDD;
            @(negedge clk);
            wren = 0;

            rd1en = 1; rd1addr = 5'd0;
            rd2en = 1; rd2addr = 5'd31;

            #1;


            check_outputs(128'hAAAA_AAAA_AAAA_AAAA_BBBB_BBBB_BBBB_BBBB, 128'hCCCC_CCCC_CCCC_CCCC_DDDD_DDDD_DDDD_DDDD);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(negedge clk);
            wren = 1; wraddr = 5'd7;
            wrdata = {16{8'hAA}};
            wbyteen = 16'h5555;
            @(negedge clk);
            wren = 0;

            rd1en = 1; rd1addr = 5'd7;
            rd2en = 0;




            #1;





            check_outputs(128'h00AA00AA00AA00AA00AA00AA00AA00AA, 128'h0);
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
        input [127:0] expected_rd1data;
        input [127:0] expected_rd2data;
        begin
            if (expected_rd1data === (expected_rd1data ^ rd1data ^ expected_rd1data) &&
                expected_rd2data === (expected_rd2data ^ rd2data ^ expected_rd2data)) begin
                $display("PASS");
                $display("  Outputs: rd1data=%h, rd2data=%h",
                         rd1data, rd2data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd1data=%h, rd2data=%h",
                         expected_rd1data, expected_rd2data);
                $display("  Got:      rd1data=%h, rd2data=%h",
                         rd1data, rd2data);
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
        $dumpvars(0,clk, rd1addr, rd1en, rd2addr, rd2en, wbyteen, wraddr, wrdata, wren, rd1data, rd2data);
    end

endmodule
