`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] d;
    reg [1:0] decider;
    wire [31:0] choosen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .decider(decider),
        .choosen(choosen)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 32'hA5A5A5A5;
            b = 32'h00000000;
            c = 32'hFFFFFFFF;
            d = 32'h12345678;
            decider = 2'b00;
            $display("Test %0d: Select input A (decider=00)", test_num);
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'hFFFFFFFF;
            d = 32'h12345678;
            decider = 2'b01;
            $display("Test %0d: Select input B (decider=01)", test_num);
            #1;

            check_outputs(32'h5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'hDEADBEEF;
            d = 32'h12345678;
            decider = 2'b10;
            $display("Test %0d: Select input C (decider=10)", test_num);
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 32'hA5A5A5A5;
            b = 32'h5A5A5A5A;
            c = 32'hDEADBEEF;
            d = 32'hCAFEBABE;
            decider = 2'b11;
            $display("Test %0d: Select input D (decider=11)", test_num);
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            c = 32'hFFFFFFFF;
            d = 32'hFFFFFFFF;
            decider = 2'b00;
            $display("Test %0d: All inputs logic High", test_num);
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            decider = 2'b11;
            $display("Test %0d: All inputs logic Low", test_num);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            c = 32'hF0F0F0F0;
            d = 32'h0F0F0F0F;
            decider = 2'b10;
            $display("Test %0d: Alternating bit patterns", test_num);
            #1;

            check_outputs(32'hF0F0F0F0);
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
        input [31:0] expected_choosen;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_choosen === (expected_choosen ^ choosen ^ expected_choosen)) begin
                $display("PASS");
                $display("  Outputs: choosen=%h",
                         choosen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: choosen=%h",
                         expected_choosen);
                $display("  Got:      choosen=%h",
                         choosen);
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
