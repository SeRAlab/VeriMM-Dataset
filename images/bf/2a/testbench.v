`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] io_in_bits_addr;
    reg io_in_bits_rw;
    reg [191:0] io_in_bits_wData;
    reg [9:0] io_in_tag;
    reg io_in_valid;
    reg io_out_ready;
    reg [15:0] io_pcIn_bits_moduleId;
    reg [3:0] io_pcIn_bits_pcType;
    reg [19:0] io_pcIn_bits_pcValue;
    reg [7:0] io_pcIn_bits_portId;
    reg io_pcIn_bits_request;
    reg io_pcIn_valid;
    reg reset;
    wire io_in_ready;
    wire [191:0] io_out_bits_rData;
    wire [9:0] io_out_tag;
    wire io_out_valid;
    wire [15:0] io_pcOut_bits_moduleId;
    wire [3:0] io_pcOut_bits_pcType;
    wire [19:0] io_pcOut_bits_pcValue;
    wire [7:0] io_pcOut_bits_portId;
    wire io_pcOut_bits_request;
    wire io_pcOut_valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_in_bits_addr(io_in_bits_addr),
        .io_in_bits_rw(io_in_bits_rw),
        .io_in_bits_wData(io_in_bits_wData),
        .io_in_tag(io_in_tag),
        .io_in_valid(io_in_valid),
        .io_out_ready(io_out_ready),
        .io_pcIn_bits_moduleId(io_pcIn_bits_moduleId),
        .io_pcIn_bits_pcType(io_pcIn_bits_pcType),
        .io_pcIn_bits_pcValue(io_pcIn_bits_pcValue),
        .io_pcIn_bits_portId(io_pcIn_bits_portId),
        .io_pcIn_bits_request(io_pcIn_bits_request),
        .io_pcIn_valid(io_pcIn_valid),
        .reset(reset),
        .io_in_ready(io_in_ready),
        .io_out_bits_rData(io_out_bits_rData),
        .io_out_tag(io_out_tag),
        .io_out_valid(io_out_valid),
        .io_pcOut_bits_moduleId(io_pcOut_bits_moduleId),
        .io_pcOut_bits_pcType(io_pcOut_bits_pcType),
        .io_pcOut_bits_pcValue(io_pcOut_bits_pcValue),
        .io_pcOut_bits_portId(io_pcOut_bits_portId),
        .io_pcOut_bits_request(io_pcOut_bits_request),
        .io_pcOut_valid(io_pcOut_valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            io_in_bits_addr = 0;
            io_in_bits_rw = 0;
            io_in_bits_wData = 0;
            io_in_tag = 0;
            io_in_valid = 0;
            io_out_ready = 1;
            io_pcIn_bits_moduleId = 0;
            io_pcIn_bits_pcType = 0;
            io_pcIn_bits_pcValue = 0;
            io_pcIn_bits_portId = 0;
            io_pcIn_bits_request = 0;
            io_pcIn_valid = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write and Tag Update", test_num);
            reset_dut();


            @(posedge clk);
            io_in_valid = 1;
            io_in_bits_rw = 1;
            io_in_bits_addr = 10'h001;
            io_in_bits_wData = 192'hA5A5A5A5_B4B4B4B4_C3C3C3C3_D2D2D2D2_E1E1E1E1_F0F0F0F0;
            io_in_tag = 10'h123;

            @(posedge clk);
            io_in_valid = 0;


            @(posedge clk);



            #1;




            check_outputs(1'b1, 192'h0, 10'h123, 1'b1, 16'h0, 4'h0, 20'h0, 8'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data Read and New Tag", test_num);
            reset_dut();


            @(posedge clk);
            io_in_valid = 1;
            io_in_bits_rw = 1;
            io_in_bits_addr = 10'h005;
            io_in_bits_wData = 192'hFEDCBA98_76543210_FEDCBA98_76543210_FEDCBA98_76543210;
            io_in_tag = 10'h0AA;

            @(posedge clk);

            io_in_valid = 1;
            io_in_bits_rw = 0;
            io_in_bits_addr = 10'h005;
            io_in_tag = 10'h3FF;

            @(posedge clk);
            io_in_valid = 0;

            @(posedge clk);

            #1;


            check_outputs(1'b1, 192'hFEDCBA98_76543210_FEDCBA98_76543210_FEDCBA98_76543210, 10'h3FF, 1'b1, 16'h0, 4'h0, 20'h0, 8'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Reset Validity", test_num);
            reset_dut();

            @(posedge clk);
            io_in_valid = 1;
            io_in_tag = 10'h055;

            @(posedge clk);

            if (io_out_valid !== 1'b1) $display("Error: Expected valid before reset");

            reset = 1;
            @(posedge clk);
            reset = 0;

            @(posedge clk);

            #1;


            check_outputs(1'b1, 192'h0, 10'h0, 1'b0, 16'h0, 4'h0, 20'h0, 8'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: PC Interface Propagation", test_num);
            reset_dut();

            @(posedge clk);
            io_pcIn_valid = 1;
            io_pcIn_bits_request = 1;
            io_pcIn_bits_moduleId = 16'hDEAD;
            io_pcIn_bits_portId = 8'hBE;
            io_pcIn_bits_pcValue = 20'h12345;
            io_pcIn_bits_pcType = 4'hF;

            @(posedge clk);


            #1;



            check_outputs(1'b1, 192'h0, 10'h0, 1'b0, 16'hDEAD, 4'hF, 20'h12345, 8'hBE, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Tag Update Only", test_num);
            reset_dut();

            @(posedge clk);
            io_in_valid = 1;
            io_in_bits_rw = 0;
            io_in_tag = 10'h2BB;

            @(posedge clk);
            io_in_valid = 0;

            @(posedge clk);

            #1;


            check_outputs(1'b1, 192'h0, 10'h2BB, 1'b1, 16'h0, 4'h0, 20'h0, 8'h0, 1'b0, 1'b0);
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
        input expected_io_in_ready;
        input [191:0] expected_io_out_bits_rData;
        input [9:0] expected_io_out_tag;
        input expected_io_out_valid;
        input [15:0] expected_io_pcOut_bits_moduleId;
        input [3:0] expected_io_pcOut_bits_pcType;
        input [19:0] expected_io_pcOut_bits_pcValue;
        input [7:0] expected_io_pcOut_bits_portId;
        input expected_io_pcOut_bits_request;
        input expected_io_pcOut_valid;
        begin
            if (expected_io_in_ready === (expected_io_in_ready ^ io_in_ready ^ expected_io_in_ready) &&
                expected_io_out_bits_rData === (expected_io_out_bits_rData ^ io_out_bits_rData ^ expected_io_out_bits_rData) &&
                expected_io_out_tag === (expected_io_out_tag ^ io_out_tag ^ expected_io_out_tag) &&
                expected_io_out_valid === (expected_io_out_valid ^ io_out_valid ^ expected_io_out_valid) &&
                expected_io_pcOut_bits_moduleId === (expected_io_pcOut_bits_moduleId ^ io_pcOut_bits_moduleId ^ expected_io_pcOut_bits_moduleId) &&
                expected_io_pcOut_bits_pcType === (expected_io_pcOut_bits_pcType ^ io_pcOut_bits_pcType ^ expected_io_pcOut_bits_pcType) &&
                expected_io_pcOut_bits_pcValue === (expected_io_pcOut_bits_pcValue ^ io_pcOut_bits_pcValue ^ expected_io_pcOut_bits_pcValue) &&
                expected_io_pcOut_bits_portId === (expected_io_pcOut_bits_portId ^ io_pcOut_bits_portId ^ expected_io_pcOut_bits_portId) &&
                expected_io_pcOut_bits_request === (expected_io_pcOut_bits_request ^ io_pcOut_bits_request ^ expected_io_pcOut_bits_request) &&
                expected_io_pcOut_valid === (expected_io_pcOut_valid ^ io_pcOut_valid ^ expected_io_pcOut_valid)) begin
                $display("PASS");
                $display("  Outputs: io_in_ready=%b, io_out_bits_rData=%h, io_out_tag=%h, io_out_valid=%b, io_pcOut_bits_moduleId=%h, io_pcOut_bits_pcType=%h, io_pcOut_bits_pcValue=%h, io_pcOut_bits_portId=%h, io_pcOut_bits_request=%b, io_pcOut_valid=%b",
                         io_in_ready, io_out_bits_rData, io_out_tag, io_out_valid, io_pcOut_bits_moduleId, io_pcOut_bits_pcType, io_pcOut_bits_pcValue, io_pcOut_bits_portId, io_pcOut_bits_request, io_pcOut_valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_in_ready=%b, io_out_bits_rData=%h, io_out_tag=%h, io_out_valid=%b, io_pcOut_bits_moduleId=%h, io_pcOut_bits_pcType=%h, io_pcOut_bits_pcValue=%h, io_pcOut_bits_portId=%h, io_pcOut_bits_request=%b, io_pcOut_valid=%b",
                         expected_io_in_ready, expected_io_out_bits_rData, expected_io_out_tag, expected_io_out_valid, expected_io_pcOut_bits_moduleId, expected_io_pcOut_bits_pcType, expected_io_pcOut_bits_pcValue, expected_io_pcOut_bits_portId, expected_io_pcOut_bits_request, expected_io_pcOut_valid);
                $display("  Got:      io_in_ready=%b, io_out_bits_rData=%h, io_out_tag=%h, io_out_valid=%b, io_pcOut_bits_moduleId=%h, io_pcOut_bits_pcType=%h, io_pcOut_bits_pcValue=%h, io_pcOut_bits_portId=%h, io_pcOut_bits_request=%b, io_pcOut_valid=%b",
                         io_in_ready, io_out_bits_rData, io_out_tag, io_out_valid, io_pcOut_bits_moduleId, io_pcOut_bits_pcType, io_pcOut_bits_pcValue, io_pcOut_bits_portId, io_pcOut_bits_request, io_pcOut_valid);
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
        $dumpvars(0,clk, io_in_bits_addr, io_in_bits_rw, io_in_bits_wData, io_in_tag, io_in_valid, io_out_ready, io_pcIn_bits_moduleId, io_pcIn_bits_pcType, io_pcIn_bits_pcValue, io_pcIn_bits_portId, io_pcIn_bits_request, io_pcIn_valid, reset, io_in_ready, io_out_bits_rData, io_out_tag, io_out_valid, io_pcOut_bits_moduleId, io_pcOut_bits_pcType, io_pcOut_bits_pcValue, io_pcOut_bits_portId, io_pcOut_bits_request, io_pcOut_valid);
    end

endmodule
