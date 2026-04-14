`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] Control;
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Control(Control),
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select input 'a' (Control=00)", test_num);
        a = 32'h1111_1111;
        b = 32'h2222_2222;
        c = 32'h3333_3333;
        d = 32'h4444_4444;
        Control = 2'b00;
        #1;

        check_outputs(32'h1111_1111);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select input 'b' (Control=01)", test_num);
        a = 32'hAAAA_AAAA;
        b = 32'hBBBB_BBBB;
        c = 32'hCCCC_CCCC;
        d = 32'hDDDD_DDDD;
        Control = 2'b01;
        #1;

        check_outputs(32'hBBBB_BBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select input 'c' (Control=10)", test_num);
        a = 32'h1234_5678;
        b = 32'h8765_4321;
        c = 32'hDEAD_BEEF;
        d = 32'hCAFE_BABE;
        Control = 2'b10;
        #1;

        check_outputs(32'hDEAD_BEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select input 'd' (Control=11)", test_num);
        a = 32'h0000_0000;
        b = 32'hFFFF_FFFF;
        c = 32'h5555_5555;
        d = 32'hAAAA_AAAA;
        Control = 2'b11;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify all inputs as 0 with Control=10", test_num);
        a = 32'h0;
        b = 32'h0;
        c = 32'h0;
        d = 32'h0;
        Control = 2'b10;
        #1;

        check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify all inputs as 1s with Control=01", test_num);
        a = 32'hFFFF_FFFF;
        b = 32'hFFFF_FFFF;
        c = 32'hFFFF_FFFF;
        d = 32'hFFFF_FFFF;
        Control = 2'b01;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Check specific bit patterns for input 'a'", test_num);
        a = 32'hF0F0_F0F0;
        b = 32'h0F0F_0F0F;
        c = 32'hFFFF_0000;
        d = 32'h0000_FFFF;
        Control = 2'b00;
        #1;

        check_outputs(32'hF0F0_F0F0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Verify input 'd' with random-looking data", test_num);
        a = 32'hA5A5_A5A5;
        b = 32'h5A5A_5A5A;
        c = 32'h3C3C_3C3C;
        d = 32'hC3C3_C3C3;
        Control = 2'b11;
        #1;

        check_outputs(32'hC3C3_C3C3);
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
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
