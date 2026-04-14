`timescale 1ns/1ps

module arithmetic_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [1:0] control;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    arithmetic_module dut (
        .a(a),
        .b(b),
        .control(control),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=00, a=0000, b=0000", test_num);
        control = 2'b00; a = 4'b0000; b = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=00, a=0000, b=0001", test_num);
        control = 2'b00; a = 4'b0000; b = 4'b0001;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=00, a=0001, b=0000", test_num);
        control = 2'b00; a = 4'b0001; b = 4'b0000;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=00, a=0001, b=0001", test_num);
        control = 2'b00; a = 4'b0001; b = 4'b0001;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=01, a=0000, b=0000", test_num);
        control = 2'b01; a = 4'b0000; b = 4'b0000;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=01, a=0000, b=0001", test_num);
        control = 2'b01; a = 4'b0000; b = 4'b0001;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=01, a=0001, b=0000", test_num);
        control = 2'b01; a = 4'b0001; b = 4'b0000;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=01, a=0001, b=0001", test_num);
        control = 2'b01; a = 4'b0001; b = 4'b0001;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=00, a=2, b=2 (Sum=4, Negated=-4)", test_num);
        control = 2'b00; a = 4'd2; b = 4'd2;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Control=01, a=10, b=3", test_num);
        control = 2'b01; a = 4'd10; b = 4'd3;
        #1;

        check_outputs(4'd7);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("arithmetic_module Testbench");
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
        input [3:0] expected_out;
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
