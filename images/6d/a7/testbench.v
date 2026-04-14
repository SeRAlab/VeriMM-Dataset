`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] sc;
    reg [31:0] x;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sc(sc),
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        x = 32'hFFFFFFFF;
        sc = 5'b00000;
        $display("Test %0d: No shift (sc=0), x=%h", test_num, x);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        x = 32'h00000001;
        sc = 5'b00001;
        $display("Test %0d: Shift by 1 bit, x=%h", test_num, x);
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        x = 32'h00000001;
        sc = 5'b00011;
        $display("Test %0d: Shift by 3 bits (Stage 1 max), x=%h", test_num, x);
        #1;

        check_outputs(32'h00000008);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        x = 32'h00000001;
        sc = 5'b00100;
        $display("Test %0d: Shift by 4 bits (Stage 2 min), x=%h", test_num, x);
        #1;

        check_outputs(32'h00000010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        x = 32'h00000001;
        sc = 5'b01100;
        $display("Test %0d: Shift by 12 bits (Stage 2 max), x=%h", test_num, x);
        #1;

        check_outputs(32'h00001000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        x = 32'hFFFFFFFF;
        sc = 5'b01111;
        $display("Test %0d: Max shift (15 bits), x=%h", test_num, x);
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        x = 32'h80000000;
        sc = 5'b00001;
        $display("Test %0d: Shift high bit out, x=%h", test_num, x);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        x = 32'hA5A5A5A5;
        sc = 5'b01000;
        $display("Test %0d: Pattern shift (8 bits), x=%h", test_num, x);
        #1;

        check_outputs(32'hA5A5A500);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        x = 32'h00000001;
        sc = 5'b10001;
        $display("Test %0d: Testing sc[4] (ignored per spec max 15), sc=%b, x=%h", test_num, sc, x);

        #1;


        check_outputs(32'h00000002);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        x = 32'h12345678;
        sc = 5'b00110;
        $display("Test %0d: Random data shift (6 bits), x=%h", test_num, x);




        #1;





        check_outputs(32'h48D159E0);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
