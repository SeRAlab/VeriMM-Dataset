`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] busA;
    reg [31:0] sel;
    wire [31:0] busSLL;
    wire cSLL;
    wire nSLL;
    wire oSLL;
    wire zSLL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .busA(busA),
        .sel(sel),
        .busSLL(busSLL),
        .cSLL(cSLL),
        .nSLL(nSLL),
        .oSLL(oSLL),
        .zSLL(zSLL)
    );
    task testcase001;

        begin
            test_num = 1;
            busA = 32'hABCD_1234;
            sel = 32'd0;

            #1;


            check_outputs(32'hABCD_1234, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            busA = 32'h8000_0001;
            sel = 32'd1;

            #1;


            check_outputs(32'h0000_0002, 1'b1, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            busA = 32'h0000_0001;
            sel = 32'd31;

            #1;


            check_outputs(32'h8000_0000, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            busA = 32'h8000_0000;
            sel = 32'd1;

            #1;


            check_outputs(32'h0000_0000, 1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            busA = 32'hFFFF_FFFF;
            sel = 32'd16;

            #1;


            check_outputs(32'hFFFF_0000, 1'b1, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            busA = 32'h7FFF_FFFF;
            sel = 32'd1;

            #1;


            check_outputs(32'hFFFF_FFFE, 1'b0, 1'b1, 1'b0, 1'b0);
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
        input [31:0] expected_busSLL;
        input expected_cSLL;
        input expected_nSLL;
        input expected_oSLL;
        input expected_zSLL;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busSLL === (expected_busSLL ^ busSLL ^ expected_busSLL) &&
                expected_cSLL === (expected_cSLL ^ cSLL ^ expected_cSLL) &&
                expected_nSLL === (expected_nSLL ^ nSLL ^ expected_nSLL) &&
                expected_oSLL === (expected_oSLL ^ oSLL ^ expected_oSLL) &&
                expected_zSLL === (expected_zSLL ^ zSLL ^ expected_zSLL)) begin
                $display("PASS");
                $display("  Outputs: busSLL=%h, cSLL=%b, nSLL=%b, oSLL=%b, zSLL=%b",
                         busSLL, cSLL, nSLL, oSLL, zSLL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busSLL=%h, cSLL=%b, nSLL=%b, oSLL=%b, zSLL=%b",
                         expected_busSLL, expected_cSLL, expected_nSLL, expected_oSLL, expected_zSLL);
                $display("  Got:      busSLL=%h, cSLL=%b, nSLL=%b, oSLL=%b, zSLL=%b",
                         busSLL, cSLL, nSLL, oSLL, zSLL);
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
