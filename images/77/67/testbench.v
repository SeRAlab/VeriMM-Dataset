`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] pc_const;
    reg [4:0] pc_plus_4;
    reg [1:0] pcsel;
    reg [31:0] rd1;
    wire [4:0] pc_from_pcsel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc_const(pc_const),
        .pc_plus_4(pc_plus_4),
        .pcsel(pcsel),
        .rd1(rd1),
        .pc_from_pcsel(pc_from_pcsel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case 001: pcsel=00 (pc_plus_4)");
        pc_plus_4 = 5'h15;
        pc_const  = 5'h0A;
        rd1       = 32'h000000FF;
        pcsel     = 2'b00;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case 002: pcsel=01 (pc_const)");
        pc_plus_4 = 5'h04;
        pc_const  = 5'h1E;
        rd1       = 32'h000000AA;
        pcsel     = 2'b01;
        #1;

        check_outputs(5'h1E);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case 003: pcsel=10 (rd1[4:0])");
        pc_plus_4 = 5'h00;
        pc_const  = 5'h00;
        rd1       = 32'h00000012;
        pcsel     = 2'b10;
        #1;

        check_outputs(5'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case 004: pcsel=10 (rd1 high bits ignored)");
        pc_plus_4 = 5'h00;
        pc_const  = 5'h00;
        rd1       = 32'hFFFF_FFED;
        pcsel     = 2'b10;
        #1;

        check_outputs(5'h0D);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case 005: Max value selection");
        pc_plus_4 = 5'h1F;
        pc_const  = 5'h1F;
        rd1       = 32'hFFFF_FFFF;
        pcsel     = 2'b01;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case 006: pcsel=00 (Zero check)");
        pc_plus_4 = 5'h00;
        pc_const  = 5'h1F;
        rd1       = 32'hFFFF_FFFF;
        pcsel     = 2'b00;
        #1;

        check_outputs(5'h00);
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
        input [4:0] expected_pc_from_pcsel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pc_from_pcsel === (expected_pc_from_pcsel ^ pc_from_pcsel ^ expected_pc_from_pcsel)) begin
                $display("PASS");
                $display("  Outputs: pc_from_pcsel=%h",
                         pc_from_pcsel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_from_pcsel=%h",
                         expected_pc_from_pcsel);
                $display("  Got:      pc_from_pcsel=%h",
                         pc_from_pcsel);
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
