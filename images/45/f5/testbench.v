`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] EOp;
    reg [15:0] imm;
    wire [31:0] ext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EOp(EOp),
        .imm(imm),
        .ext(ext)
    );
    task testcase001;

        begin
            test_num = 1;
            imm = 16'h1234;
            EOp = 2'b00;
            $display("Test Case %0d: EOp=00 (Sign Ext), imm=0x1234", test_num);
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            imm = 16'h8ABC;
            EOp = 2'b00;
            $display("Test Case %0d: EOp=00 (Sign Ext), imm=0x8ABC", test_num);
            #1;

            check_outputs(32'hFFFF8ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            imm = 16'h1234;
            EOp = 2'b01;
            $display("Test Case %0d: EOp=01 (Zero Ext), imm=0x1234", test_num);
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            imm = 16'h8ABC;
            EOp = 2'b01;
            $display("Test Case %0d: EOp=01 (Zero Ext), imm=0x8ABC", test_num);
            #1;

            check_outputs(32'h00008ABC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            imm = 16'h5555;
            EOp = 2'b10;
            $display("Test Case %0d: EOp=10 (Zero Ext), imm=0x5555", test_num);
            #1;

            check_outputs(32'h00005555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            imm = 16'hAAAA;
            EOp = 2'b10;
            $display("Test Case %0d: EOp=10 (Zero Ext), imm=0xAAAA", test_num);
            #1;

            check_outputs(32'h0000AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            imm = 16'h0001;
            EOp = 2'b11;
            $display("Test Case %0d: EOp=11 (Sign Ext + Shift), imm=0x0001", test_num);

            #1;


            check_outputs(32'h00000004);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            imm = 16'h8000;
            EOp = 2'b11;
            $display("Test Case %0d: EOp=11 (Sign Ext + Shift), imm=0x8000", test_num);

            #1;


            check_outputs(32'hFFFE0000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            imm = 16'h0000;
            EOp = 2'b00;
            $display("Test Case %0d: EOp=00 (Sign Ext), imm=0x0000", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            imm = 16'hFFFF;
            EOp = 2'b11;
            $display("Test Case %0d: EOp=11 (Sign Ext + Shift), imm=0xFFFF", test_num);

            #1;


            check_outputs(32'hFFFFFFFC);
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
        testcase009();
        testcase010();
        
        
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
        input [31:0] expected_ext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ext === (expected_ext ^ ext ^ expected_ext)) begin
                $display("PASS");
                $display("  Outputs: ext=%h",
                         ext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ext=%h",
                         expected_ext);
                $display("  Got:      ext=%h",
                         ext);
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
