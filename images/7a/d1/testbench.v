`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control_rdata_a;
    reg control_rdata_b;
    reg [31:0] ex_rdata_a;
    reg [31:0] ex_rdata_b;
    reg [31:0] mem_wb_dout;
    wire [31:0] rdata_a;
    wire [31:0] rdata_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control_rdata_a(control_rdata_a),
        .control_rdata_b(control_rdata_b),
        .ex_rdata_a(ex_rdata_a),
        .ex_rdata_b(ex_rdata_b),
        .mem_wb_dout(mem_wb_dout),
        .rdata_a(rdata_a),
        .rdata_b(rdata_b)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Execution stage for both (control=0)", test_num);
            ex_rdata_a = 32'h1111_1111;
            ex_rdata_b = 32'h2222_2222;
            mem_wb_dout = 32'hFFFF_FFFF;
            control_rdata_a = 1'b0;
            control_rdata_b = 1'b0;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Memory Write-Back stage for both (control=1)", test_num);
            ex_rdata_a = 32'hAAAA_AAAA;
            ex_rdata_b = 32'hBBBB_BBBB;
            mem_wb_dout = 32'h5555_5555;
            control_rdata_a = 1'b1;
            control_rdata_b = 1'b1;
            #1;

            check_outputs(32'h5555_5555, 32'h5555_5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Mixed selection (A=Mem, B=Ex)", test_num);
            ex_rdata_a = 32'hDEAF_BEEF;
            ex_rdata_b = 32'h1234_5678;
            mem_wb_dout = 32'h9999_0000;
            control_rdata_a = 1'b1;
            control_rdata_b = 1'b0;
            #1;

            check_outputs(32'h9999_0000, 32'h1234_5678);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mixed selection (A=Ex, B=Mem)", test_num);
            ex_rdata_a = 32'hCAFE_BABE;
            ex_rdata_b = 32'h8765_4321;
            mem_wb_dout = 32'h0000_AAAA;
            control_rdata_a = 1'b0;
            control_rdata_b = 1'b1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'h0000_AAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: All zeros and ones data check", test_num);
            ex_rdata_a = 32'hFFFF_FFFF;
            ex_rdata_b = 32'h0000_0000;
            mem_wb_dout = 32'h5A5A_A5A5;
            control_rdata_a = 1'b0;
            control_rdata_b = 1'b1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'h5A5A_A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verify independent switching of A", test_num);
            ex_rdata_a = 32'hDEAD_BEEF;
            ex_rdata_b = 32'h0000_0000;
            mem_wb_dout = 32'h1111_2222;
            control_rdata_b = 1'b0;


            control_rdata_a = 1'b0;
            #1;
            control_rdata_a = 1'b1;
            #1;

            check_outputs(32'h1111_2222, 32'h0000_0000);
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
        input [31:0] expected_rdata_a;
        input [31:0] expected_rdata_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_rdata_a === (expected_rdata_a ^ rdata_a ^ expected_rdata_a) &&
                expected_rdata_b === (expected_rdata_b ^ rdata_b ^ expected_rdata_b)) begin
                $display("PASS");
                $display("  Outputs: rdata_a=%h, rdata_b=%h",
                         rdata_a, rdata_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata_a=%h, rdata_b=%h",
                         expected_rdata_a, expected_rdata_b);
                $display("  Got:      rdata_a=%h, rdata_b=%h",
                         rdata_a, rdata_b);
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
