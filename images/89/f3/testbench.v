`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] MFRTMout;
    reg [31:0] address;
    reg [1:0] sel;
    wire [31:0] Wdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .MFRTMout(MFRTMout),
        .address(address),
        .sel(sel),
        .Wdata(Wdata)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Word Mode (sel=10, addr=0)", test_num);
        MFRTMout = 32'hDEADBEEF;
        address  = 32'h00001000;
        sel      = 2'b10;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Halfword Mode Lower (sel=01, addr=0)", test_num);
        MFRTMout = 32'hAAAABBBB;
        address  = 32'h00001000;
        sel      = 2'b01;
        #1;

        check_outputs(32'h0000BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Halfword Mode Upper (sel=01, addr=2)", test_num);
        MFRTMout = 32'hAAAABBBB;
        address  = 32'h00001002;
        sel      = 2'b01;
        #1;

        check_outputs(32'hBBBB0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Byte Mode Lane 0 (sel=00, addr=0)", test_num);
        MFRTMout = 32'h11223344;
        address  = 32'h00001000;
        sel      = 2'b00;
        #1;

        check_outputs(32'h00000044);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Byte Mode Lane 1 (sel=00, addr=1)", test_num);
        MFRTMout = 32'h11223344;
        address  = 32'h00001001;
        sel      = 2'b00;
        #1;

        check_outputs(32'h00004400);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Byte Mode Lane 2 (sel=00, addr=2)", test_num);
        MFRTMout = 32'h11223344;
        address  = 32'h00001002;
        sel      = 2'b00;
        #1;

        check_outputs(32'h00440000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Byte Mode Lane 3 (sel=00, addr=3)", test_num);
        MFRTMout = 32'h11223344;
        address  = 32'h00001003;
        sel      = 2'b00;
        #1;

        check_outputs(32'h44000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Word Mode with non-zero address offset", test_num);
        MFRTMout = 32'h87654321;
        address  = 32'h00001003;
        sel      = 2'b10;
        #1;

        check_outputs(32'h87654321);
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
        input [31:0] expected_Wdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Wdata === (expected_Wdata ^ Wdata ^ expected_Wdata)) begin
                $display("PASS");
                $display("  Outputs: Wdata=%h",
                         Wdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Wdata=%h",
                         expected_Wdata);
                $display("  Got:      Wdata=%h",
                         Wdata);
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
