`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] io_ins_0_0_addr;
    reg io_ins_0_0_isWr;
    reg [15:0] io_ins_0_0_size;
    reg [63:0] io_ins_1_0_addr;
    reg io_ins_1_0_isWr;
    reg [15:0] io_ins_1_0_size;
    reg io_sel;
    wire [63:0] io_out_0_addr;
    wire io_out_0_isWr;
    wire [15:0] io_out_0_size;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .io_ins_0_0_addr(io_ins_0_0_addr),
        .io_ins_0_0_isWr(io_ins_0_0_isWr),
        .io_ins_0_0_size(io_ins_0_0_size),
        .io_ins_1_0_addr(io_ins_1_0_addr),
        .io_ins_1_0_isWr(io_ins_1_0_isWr),
        .io_ins_1_0_size(io_ins_1_0_size),
        .io_sel(io_sel),
        .io_out_0_addr(io_out_0_addr),
        .io_out_0_isWr(io_out_0_isWr),
        .io_out_0_size(io_out_0_size)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input 0", test_num);


            io_ins_0_0_addr = 64'hDEADBEEF_CAFEBABE;
            io_ins_0_0_isWr = 1'b1;
            io_ins_0_0_size = 16'h0008;

            io_ins_1_0_addr = 64'h12345678_9ABCDEF0;
            io_ins_1_0_isWr = 1'b0;
            io_ins_1_0_size = 16'h0004;

            io_sel = 1'b0;


            #1;



            check_outputs(64'hDEADBEEF_CAFEBABE, 1'b1, 16'h0008);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select Input 1", test_num);


            io_ins_0_0_addr = 64'hDEADBEEF_CAFEBABE;
            io_ins_0_0_isWr = 1'b1;
            io_ins_0_0_size = 16'h0008;

            io_ins_1_0_addr = 64'h12345678_9ABCDEF0;
            io_ins_1_0_isWr = 1'b0;
            io_ins_1_0_size = 16'h0004;

            io_sel = 1'b1;


            #1;



            check_outputs(64'h12345678_9ABCDEF0, 1'b0, 16'h0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Values - All Zeros (Sel 0)", test_num);

            io_ins_0_0_addr = 64'h0;
            io_ins_0_0_isWr = 1'b0;
            io_ins_0_0_size = 16'h0;

            io_ins_1_0_addr = 64'hFFFFFFFF_FFFFFFFF;
            io_ins_1_0_isWr = 1'b1;
            io_ins_1_0_size = 16'hFFFF;

            io_sel = 1'b0;

            #1;


            check_outputs(64'h0, 1'b0, 16'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Values - All Ones (Sel 1)", test_num);

            io_ins_0_0_addr = 64'h0;
            io_ins_0_0_isWr = 1'b0;
            io_ins_0_0_size = 16'h0;

            io_ins_1_0_addr = 64'hFFFFFFFF_FFFFFFFF;
            io_ins_1_0_isWr = 1'b1;
            io_ins_1_0_size = 16'hFFFF;

            io_sel = 1'b1;

            #1;


            check_outputs(64'hFFFFFFFF_FFFFFFFF, 1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Switching Selection with same inputs", test_num);

            io_ins_0_0_addr = 64'hAAAA_AAAA_AAAA_AAAA;
            io_ins_0_0_isWr = 1'b1;
            io_ins_0_0_size = 16'hAAAA;

            io_ins_1_0_addr = 64'h5555_5555_5555_5555;
            io_ins_1_0_isWr = 1'b0;
            io_ins_1_0_size = 16'h5555;

            io_sel = 1'b0;
            #5;
            io_sel = 1'b1;

            #1;


            check_outputs(64'h5555_5555_5555_5555, 1'b0, 16'h5555);
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
        input [63:0] expected_io_out_0_addr;
        input expected_io_out_0_isWr;
        input [15:0] expected_io_out_0_size;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_out_0_addr === (expected_io_out_0_addr ^ io_out_0_addr ^ expected_io_out_0_addr) &&
                expected_io_out_0_isWr === (expected_io_out_0_isWr ^ io_out_0_isWr ^ expected_io_out_0_isWr) &&
                expected_io_out_0_size === (expected_io_out_0_size ^ io_out_0_size ^ expected_io_out_0_size)) begin
                $display("PASS");
                $display("  Outputs: io_out_0_addr=%h, io_out_0_isWr=%b, io_out_0_size=%h",
                         io_out_0_addr, io_out_0_isWr, io_out_0_size);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_out_0_addr=%h, io_out_0_isWr=%b, io_out_0_size=%h",
                         expected_io_out_0_addr, expected_io_out_0_isWr, expected_io_out_0_size);
                $display("  Got:      io_out_0_addr=%h, io_out_0_isWr=%b, io_out_0_size=%h",
                         io_out_0_addr, io_out_0_isWr, io_out_0_size);
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
