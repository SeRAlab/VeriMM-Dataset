`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [32:0] a;
    reg [32:0] b;
    reg [32:0] base;
    reg [32:0] enf;
    reg [32:0] load;
    reg [32:0] qtd;
    reg reset;
    reg sysclk;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .base(base),
        .enf(enf),
        .load(load),
        .qtd(qtd),
        .reset(reset),
        .sysclk(sysclk)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset Behavior", test_num);
            reset = 1;
            a = 33'h0; b = 33'h0; base = 33'h0;
            enf = 33'h0; load = 33'h0; qtd = 33'h0;
            repeat(2) @(posedge sysclk);
            reset = 0;
            @(posedge sysclk);
            #1;

            check_outputs(33'h0, 33'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Inputs Set to High", test_num);
            reset = 1; #10; reset = 0;
            a = 33'h1FFFFFFFF;
            b = 33'h1FFFFFFFF;
            base = 33'h1FFFFFFFF;
            enf = 33'h1FFFFFFFF;
            load = 33'h1FFFFFFFF;
            qtd = 33'h1FFFFFFFF;
            repeat(2) @(posedge sysclk);
            #1;

            check_outputs(33'h1FFFFFFFF, 33'h1FFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Alternating Bit Pattern", test_num);
            reset = 1; #10; reset = 0;
            a = 33'h0AAAAAAAA;
            b = 33'h155555555;
            base = 33'h0F0F0F0F0;
            enf = 33'h1E1E1E1E1;
            load = 33'h00000FFFF;
            qtd = 33'h1FFFF0000;
            repeat(2) @(posedge sysclk);
            #1;

            check_outputs(33'h0, 33'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary Shift Check", test_num);
            reset = 1; #10; reset = 0;
            a = 33'h1;
            b = 33'h2;
            base = 33'h4;
            enf = 33'h8;
            load = 33'h10;
            qtd = 33'h20;
            repeat(2) @(posedge sysclk);
            #1;

            check_outputs(33'h0, 33'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Complex Concatenation Verification", test_num);
            reset = 1; #10; reset = 0;
            a = 33'h123456789;
            b = 33'h198765432;
            base = 33'h0ABCDEF12;
            enf = 33'h111111111;
            load = 33'h0;
            qtd = 33'h1AAAAAAAA;
            repeat(5) @(posedge sysclk);
            #1;

            check_outputs(33'h0, 33'h0);
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
