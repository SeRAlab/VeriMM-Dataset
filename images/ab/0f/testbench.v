`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] pba;
    reg [255:0] pt;
    reg [7:0] va;
    wire [7:0] pa;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pba(pba),
        .pt(pt),
        .va(va),
        .pa(pa),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic translation at VA=0, Valid bit set", test_num);
            va = 8'h00;
            pba = 8'h10;
            pt = 256'b0;
            pt[0] = 1'b1;
            #1;

            check_outputs(8'h10, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic translation at VA=0, Valid bit clear", test_num);
            va = 8'h00;
            pba = 8'h10;
            pt = 256'b0;
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translation with VA=0x05 and PBA=0x20", test_num);
            va = 8'h05;
            pba = 8'h20;
            pt = 256'b0;
            pt[5] = 1'b1;
            #1;

            check_outputs(8'h25, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Translation at max VA=0xFF", test_num);
            va = 8'hFF;
            pba = 8'h01;
            pt = 256'b0;
            pt[255] = 1'b1;
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check specific bit indexing (VA=0x80)", test_num);
            va = 8'h80;
            pba = 8'h00;
            pt = 256'b0;
            pt[128] = 1'b1;
            #1;

            check_outputs(8'h80, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Noise in PT (VA=0x0F is valid, others are too)", test_num);
            va = 8'h0F;
            pba = 8'hA0;
            pt = 256'hFFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(8'hAF, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: VA address clear in a sparse PT", test_num);
            va = 8'h02;
            pba = 8'h00;
            pt = 256'h0;
            pt[1] = 1'b1;
            pt[3] = 1'b1;

            #1;


            check_outputs(8'h00, 1'b0);
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
        input [7:0] expected_pa;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pa === (expected_pa ^ pa ^ expected_pa) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: pa=%h, valid=%b",
                         pa, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pa=%h, valid=%b",
                         expected_pa, expected_valid);
                $display("  Got:      pa=%h, valid=%b",
                         pa, valid);
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
