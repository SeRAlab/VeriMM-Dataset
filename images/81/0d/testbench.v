`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] DATA_A;
    reg [4:0] DATA_B;
    reg SELECTOR;
    wire [4:0] OUTPUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_A(DATA_A),
        .DATA_B(DATA_B),
        .SELECTOR(SELECTOR),
        .OUTPUT(OUTPUT)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=0, DATA_A=5'h00, DATA_B=5'h1F", test_num);
        SELECTOR = 1'b0;
        DATA_A = 5'h00;
        DATA_B = 5'h1F;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=1, DATA_A=5'h00, DATA_B=5'h1F", test_num);
        SELECTOR = 1'b1;
        DATA_A = 5'h00;
        DATA_B = 5'h1F;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=0, DATA_A=5'h15, DATA_B=5'h0A", test_num);
        SELECTOR = 1'b0;
        DATA_A = 5'h15;
        DATA_B = 5'h0A;
        #1;

        check_outputs(5'h15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=1, DATA_A=5'h15, DATA_B=5'h0A", test_num);
        SELECTOR = 1'b1;
        DATA_A = 5'h15;
        DATA_B = 5'h0A;
        #1;

        check_outputs(5'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=0, DATA_A=5'h1F, DATA_B=5'h00", test_num);
        SELECTOR = 1'b0;
        DATA_A = 5'h1F;
        DATA_B = 5'h00;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SELECTOR=1, DATA_A=5'h1F, DATA_B=5'h00", test_num);
        SELECTOR = 1'b1;
        DATA_A = 5'h1F;
        DATA_B = 5'h00;
        #1;

        check_outputs(5'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All ones on SELECTOR 0", test_num);
        SELECTOR = 1'b0;
        DATA_A = 5'h1F;
        DATA_B = 5'h1F;
        #1;

        check_outputs(5'h1F);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bits check", test_num);
        SELECTOR = 1'b1;
        DATA_A = 5'b10101;
        DATA_B = 5'b01010;
        #1;

        check_outputs(5'b01010);
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
        input [4:0] expected_OUTPUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_OUTPUT === (expected_OUTPUT ^ OUTPUT ^ expected_OUTPUT)) begin
                $display("PASS");
                $display("  Outputs: OUTPUT=%h",
                         OUTPUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUTPUT=%h",
                         expected_OUTPUT);
                $display("  Got:      OUTPUT=%h",
                         OUTPUT);
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
