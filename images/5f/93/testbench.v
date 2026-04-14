`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg comp1;
    reg out;
    reg rd_en;
    reg [4:0] v1_reg;
    wire ram_empty_fb_i_reg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .comp1(comp1),
        .out(out),
        .rd_en(rd_en),
        .v1_reg(v1_reg),
        .ram_empty_fb_i_reg(ram_empty_fb_i_reg)
    );
    task testcase001;

    begin
        $display("Testcase 001: All inputs zero - checking base state");
        test_num = 1;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: v1_reg at minimum non-zero value");
        test_num = 2;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        v1_reg = 5'b00001;

        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: v1_reg at maximum value");
        test_num = 3;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        v1_reg = 5'b11111;

        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: rd_en active with v1_reg = 1");
        test_num = 4;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        v1_reg = 5'b00001;
        rd_en = 1'b1;

        #10;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: comp1 control signal influence");
        test_num = 5;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        v1_reg = 5'b01010;
        comp1 = 1'b1;

        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: out signal influence at v1_reg = 0");
        test_num = 6;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        out = 1'b1;

        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Multiple control signals active");
        test_num = 7;

        v1_reg = 5'b00000;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;

        #5;
        v1_reg = 5'b00100;
        rd_en = 1'b1;
        comp1 = 1'b1;
        out = 1'b1;

        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Transition from non-empty to empty");
        test_num = 8;

        v1_reg = 5'b00010;
        rd_en = 1'b0;
        comp1 = 1'b0;
        out = 1'b0;
        #10;


        v1_reg = 5'b00000;
        rd_en = 1'b1;

        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_ram_empty_fb_i_reg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ram_empty_fb_i_reg === (expected_ram_empty_fb_i_reg ^ ram_empty_fb_i_reg ^ expected_ram_empty_fb_i_reg)) begin
                $display("PASS");
                $display("  Outputs: ram_empty_fb_i_reg=%b",
                         ram_empty_fb_i_reg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ram_empty_fb_i_reg=%b",
                         expected_ram_empty_fb_i_reg);
                $display("  Got:      ram_empty_fb_i_reg=%b",
                         ram_empty_fb_i_reg);
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
