`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] bplcon2;
    reg [5:0] bpldata;
    reg dblpf;
    wire [1:0] nplayfield;
    wire [5:0] plfdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bplcon2(bplcon2),
        .bpldata(bpldata),
        .dblpf(dblpf),
        .nplayfield(nplayfield),
        .plfdata(plfdata)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Playfield Mode - Active Data", test_num);

            dblpf = 1'b0;
            bplcon2 = 7'b0000000;
            bpldata = 6'b110111;

            #1;


            check_outputs(2'b01, 6'b110111);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Playfield Mode - Background (Zero Data)", test_num);
            dblpf = 1'b0;
            bplcon2 = 7'b0000000;
            bpldata = 6'b000000;

            #1;


            check_outputs(2'b00, 6'b000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - PF1 Priority, Both Active", test_num);



            dblpf = 1'b1;
            bplcon2 = 7'b0000000;


            bpldata = 6'b011001;


            #1;



            check_outputs(2'b01, 6'h05);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - PF1 Priority, PF1 Transparent", test_num);
            dblpf = 1'b1;
            bplcon2 = 7'b0000000;


            bpldata = 6'b001000;


            #1;



            check_outputs(2'b10, 6'h02);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - PF2 Priority, Both Active", test_num);

            dblpf = 1'b1;
            bplcon2 = 7'b1000000;


            bpldata = 6'b011001;


            #1;



            check_outputs(2'b10, 6'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - PF2 Priority, PF2 Transparent", test_num);
            dblpf = 1'b1;
            bplcon2 = 7'b1000000;


            bpldata = 6'b010001;


            #1;



            check_outputs(2'b01, 6'h05);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - Both Transparent", test_num);
            dblpf = 1'b1;
            bplcon2 = 7'b0000000;
            bpldata = 6'b000000;


            #1;



            check_outputs(2'b00, 6'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Playfield Mode - Boundary Max Values", test_num);
            dblpf = 1'b1;
            bplcon2 = 7'b1000000;


            bpldata = 6'b111111;


            #1;



            check_outputs(2'b10, 6'h07);
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
        input [1:0] expected_nplayfield;
        input [5:0] expected_plfdata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_nplayfield === (expected_nplayfield ^ nplayfield ^ expected_nplayfield) &&
                expected_plfdata === (expected_plfdata ^ plfdata ^ expected_plfdata)) begin
                $display("PASS");
                $display("  Outputs: nplayfield=%h, plfdata=%h",
                         nplayfield, plfdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: nplayfield=%h, plfdata=%h",
                         expected_nplayfield, expected_plfdata);
                $display("  Got:      nplayfield=%h, plfdata=%h",
                         nplayfield, plfdata);
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
