`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [4:0] n;
    wire [31:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .n(n),
        .b(b)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 32'h12345678;
        n = 5'b00000;
        $display("Test %0d: n=0 (No shift), a=%h", test_num, a);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 32'h00000001;
        n = 5'b00001;
        $display("Test %0d: n=1 (Left shift 1), a=%h", test_num, a);
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 32'h00000001;
        n = 5'b01111;
        $display("Test %0d: n=15 (Left shift 15), a=%h", test_num, a);
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 32'h70000000;
        n = 5'b11111;
        $display("Test %0d: n=-1 (Right shift 1), a=%h", test_num, a);
        #1;

        check_outputs(32'h38000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 32'h80000000;
        n = 5'b11111;
        $display("Test %0d: n=-1 (Right shift 1, sign extension), a=%h", test_num, a);
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 32'h80000000;
        n = 5'b10000;
        $display("Test %0d: n=-16 (Right shift 16), a=%h", test_num, a);
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 32'h0000FFFF;
        n = 5'b01010;
        $display("Test %0d: n=10 (Left shift 10), a=%h", test_num, a);
        #1;

        check_outputs(32'h03FFFC00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 32'hA0000000;
        n = 5'b11011;
        $display("Test %0d: n=-5 (Right shift 5), a=%h", test_num, a);
        #1;

        check_outputs(32'hFD000000);
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
        input [31:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
