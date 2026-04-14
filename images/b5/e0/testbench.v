`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] choose;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select in1 (choose = 2'b00)", test_num);
        in1 = 32'hDEADBEEF;
        in2 = 32'hCAFEBABE;
        in3 = 32'h12345678;
        choose = 2'b00;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select in2 (choose = 2'b01)", test_num);
        in1 = 32'hDEADBEEF;
        in2 = 32'hCAFEBABE;
        in3 = 32'h12345678;
        choose = 2'b01;
        #1;

        check_outputs(32'hCAFEBABE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select in3 (choose = 2'b10)", test_num);
        in1 = 32'hDEADBEEF;
        in2 = 32'hCAFEBABE;
        in3 = 32'h12345678;
        choose = 2'b10;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: All inputs zero, select in1", test_num);
        in1 = 32'h00000000;
        in2 = 32'h00000000;
        in3 = 32'h00000000;
        choose = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs max, select in2", test_num);
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        in3 = 32'hFFFFFFFF;
        choose = 2'b01;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Bit pattern test, select in3", test_num);
        in1 = 32'hAAAAAAAA;
        in2 = 32'h55555555;
        in3 = 32'hF0F0F0F0;
        choose = 2'b10;
        #1;

        check_outputs(32'hF0F0F0F0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Rapid input change for in1", test_num);
        in2 = 32'h0;
        in3 = 32'h0;
        choose = 2'b00;
        in1 = 32'h11111111;
        #1;
        in1 = 32'h22222222;
        #1;

        check_outputs(32'h22222222);
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
