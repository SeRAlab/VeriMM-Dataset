`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] func;
    reg [5:0] op;
    wire [4:0] aluc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .func(func),
        .op(op),
        .aluc(aluc)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: R-type ADD (op=0, func=32)", test_num);
        op = 6'b000000;
        func = 6'h20;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: R-type SUB (op=0, func=34)", test_num);
        op = 6'b000000;
        func = 6'h22;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: R-type AND (op=0, func=36)", test_num);
        op = 6'b000000;
        func = 6'h24;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: R-type OR (op=0, func=37)", test_num);
        op = 6'b000000;
        func = 6'h25;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: R-type XOR (op=0, func=38)", test_num);
        op = 6'b000000;
        func = 6'h26;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: R-type NOR (op=0, func=39)", test_num);
        op = 6'b000000;
        func = 6'h27;
        #1;

        check_outputs(5'b00101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: R-type SLL (op=0, func=0)", test_num);
        op = 6'b000000;
        func = 6'h00;
        #1;

        check_outputs(5'b00110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: R-type SRL (op=0, func=2)", test_num);
        op = 6'b000000;
        func = 6'h02;
        #1;

        check_outputs(5'b00111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: I-type ADDI (op=8)", test_num);
        op = 6'h08;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: I-type ANDI (op=12)", test_num);
        op = 6'h0c;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00010);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: I-type ORI (op=13)", test_num);
        op = 6'h0d;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00011);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: I-type XORI (op=14)", test_num);
        op = 6'h0e;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00100);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Testcase %0d: LW (op=35)", test_num);
        op = 6'h23;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Testcase %0d: SW (op=43)", test_num);
        op = 6'h2b;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Testcase %0d: BEQ (op=4)", test_num);
        op = 6'h04;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00001);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Testcase %0d: BNE (op=5)", test_num);
        op = 6'h05;
        func = 6'bxxxxxx;
        #1;

        check_outputs(5'b00001);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [4:0] expected_aluc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_aluc === (expected_aluc ^ aluc ^ expected_aluc)) begin
                $display("PASS");
                $display("  Outputs: aluc=%h",
                         aluc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aluc=%h",
                         expected_aluc);
                $display("  Got:      aluc=%h",
                         aluc);
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
