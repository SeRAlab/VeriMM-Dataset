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
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type ADD", test_num);
        op = 6'h00; func = 6'h20;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SUB", test_num);
        op = 6'h00; func = 6'h22;
        #1;

        check_outputs(5'h02);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type AND", test_num);
        op = 6'h00; func = 6'h24;
        #1;

        check_outputs(5'h04);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type OR", test_num);
        op = 6'h00; func = 6'h25;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type XOR", test_num);
        op = 6'h00; func = 6'h26;
        #1;

        check_outputs(5'h06);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type NOR", test_num);
        op = 6'h00; func = 6'h27;
        #1;

        check_outputs(5'h07);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SLT", test_num);
        op = 6'h00; func = 6'h2a;
        #1;

        check_outputs(5'h0a);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SLTU", test_num);
        op = 6'h00; func = 6'h2b;
        #1;

        check_outputs(5'h0b);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SLL", test_num);
        op = 6'h00; func = 6'h00;
        #1;

        check_outputs(5'h10);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SRL", test_num);
        op = 6'h00; func = 6'h02;
        #1;

        check_outputs(5'h11);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: R-Type SRA", test_num);
        op = 6'h00; func = 6'h03;
        #1;

        check_outputs(5'h13);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ADDI", test_num);
        op = 6'h08; func = 6'h00;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: LW", test_num);
        op = 6'h23; func = 6'h3f;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SW", test_num);
        op = 6'h2b; func = 6'h00;
        #1;

        check_outputs(5'h01);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BEQ", test_num);
        op = 6'h04; func = 6'h00;
        #1;

        check_outputs(5'h02);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: BNE", test_num);
        op = 6'h05; func = 6'h00;
        #1;

        check_outputs(5'h02);
    end
        endtask

    task testcase017;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ANDI", test_num);
        op = 6'h0c; func = 6'h00;
        #1;

        check_outputs(5'h04);
    end
        endtask

    task testcase018;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: ORI", test_num);
        op = 6'h0d; func = 6'h00;
        #1;

        check_outputs(5'h05);
    end
        endtask

    task testcase019;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: XORI", test_num);
        op = 6'h0e; func = 6'h00;
        #1;

        check_outputs(5'h06);
    end
        endtask

    task testcase020;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: SLTI", test_num);
        op = 6'h0a; func = 6'h00;
        #1;

        check_outputs(5'h0a);
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
        testcase017();
        testcase018();
        testcase019();
        testcase020();
        
        
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
