`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] In1;
    reg [31:0] In2;
    reg [31:0] In3;
    reg [31:0] In4;
    reg [1:0] Op;
    wire [31:0] Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In1(In1),
        .In2(In2),
        .In3(In3),
        .In4(In4),
        .Op(Op),
        .Out(Out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select In1 (Op=00)", test_num);
        In1 = 32'h12345678;
        In2 = 32'h0;
        In3 = 32'h0;
        In4 = 32'h0;
        Op = 2'b00;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select In2 (Op=01)", test_num);
        In1 = 32'hFFFFFFFF;
        In2 = 32'hA5A5A5A5;
        In3 = 32'h0;
        In4 = 32'h0;
        Op = 2'b01;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select In3 (Op=10)", test_num);
        In1 = 32'h11111111;
        In2 = 32'h22222222;
        In3 = 32'h33333333;
        In4 = 32'h44444444;
        Op = 2'b10;
        #1;

        check_outputs(32'h33333333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Select In4 (Op=11)", test_num);
        In1 = 32'hDEADBEEF;
        In2 = 32'hCAFEBABE;
        In3 = 32'h00001111;
        In4 = 32'h88889999;
        Op = 2'b11;
        #1;

        check_outputs(32'h88889999);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Inputs Zero", test_num);
        In1 = 32'h0; In2 = 32'h0; In3 = 32'h0; In4 = 32'h0;
        Op = 2'b00; #1;
 check_outputs(32'h0);
        Op = 2'b01; #1;
 check_outputs(32'h0);
        Op = 2'b10; #1;
 check_outputs(32'h0);
        Op = 2'b11; #1;
 check_outputs(32'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit Transition Check", test_num);
        In1 = 32'h00000001;
        In2 = 32'h00000002;
        In3 = 32'h00000004;
        In4 = 32'h00000008;
        Op = 2'b00; #1;
 check_outputs(32'h00000001);
        Op = 2'b01; #1;
 check_outputs(32'h00000002);
        Op = 2'b10; #1;
 check_outputs(32'h00000004);
        Op = 2'b11; #1;
 check_outputs(32'h00000008);
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
        input [31:0] expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%h",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%h",
                         expected_Out);
                $display("  Got:      Out=%h",
                         Out);
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
