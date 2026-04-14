`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [31:0] io_jmp_br;
    reg [31:0] io_pc;
    reg [31:0] io_pc_4;
    reg [1:0] io_pc_sel;
    reg reset;
    wire [31:0] io_to_pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_jmp_br(io_jmp_br),
        .io_pc(io_pc),
        .io_pc_4(io_pc_4),
        .io_pc_sel(io_pc_sel),
        .reset(reset),
        .io_to_pc(io_to_pc)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select io_pc_4 (io_pc_sel = 00)", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'h12345678;
            io_pc   = 32'h87654321;
            io_jmp_br = 32'hABCDEFFF;
            io_pc_sel = 2'b00;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select io_pc (io_pc_sel = 01)", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'h11112222;
            io_pc   = 32'h33334444;
            io_jmp_br = 32'h55556666;
            io_pc_sel = 2'b01;

            #1;


            check_outputs(32'h33334444);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select io_jmp_br (io_pc_sel = 10)", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'hAAAAAAAA;
            io_pc   = 32'hBBBBBBBB;
            io_jmp_br = 32'hCCCCCCCC;
            io_pc_sel = 2'b10;

            #1;


            check_outputs(32'hCCCCCCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select io_pc_4 with all Fs", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'hFFFFFFFF;
            io_pc   = 32'h00000000;
            io_jmp_br = 32'h55555555;
            io_pc_sel = 2'b00;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select io_pc with all 0s", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'hFFFFFFFF;
            io_pc   = 32'h00000000;
            io_jmp_br = 32'h55555555;
            io_pc_sel = 2'b01;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select io_jmp_br with pattern 0x55555555", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_4 = 32'hFFFFFFFF;
            io_pc   = 32'h00000000;
            io_jmp_br = 32'h55555555;
            io_pc_sel = 2'b10;

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Check mux response to data changing while select is constant", test_num);

            reset = 1;
            #10;
            reset = 0;
            #10;

            io_pc_sel = 2'b10;
            io_jmp_br = 32'h1234ABCD;
            #5;
            io_jmp_br = 32'hDEADBEEF;

            #1;


            check_outputs(32'hDEADBEEF);
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
        input [31:0] expected_io_to_pc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_io_to_pc === (expected_io_to_pc ^ io_to_pc ^ expected_io_to_pc)) begin
                $display("PASS");
                $display("  Outputs: io_to_pc=%h",
                         io_to_pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_to_pc=%h",
                         expected_io_to_pc);
                $display("  Got:      io_to_pc=%h",
                         io_to_pc);
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
