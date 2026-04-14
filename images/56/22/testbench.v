`timescale 1ns/1ps

module simple_fsm_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] c;
    reg clk;
    reg g;
    wire C;
    wire d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    simple_fsm dut (
        .c(c),
        .clk(clk),
        .g(g),
        .C(C),
        .d(d)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 000, g=0 (Next State 001, d=0)", test_num);
            c = 3'b000; g = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 000, g=1 (Next State 010, d=0)", test_num);
            c = 3'b000; g = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 001, g=0 (Next State 011, d=1)", test_num);
            c = 3'b001; g = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 001, g=1 (Next State 000, d=1)", test_num);
            c = 3'b001; g = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 010, g=0 (Next State 001, d=0)", test_num);
            c = 3'b010; g = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 010, g=1 (Next State 100, d=0)", test_num);
            c = 3'b010; g = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 011, g=0 (Next State 000, d=1)", test_num);
            c = 3'b011; g = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 011, g=1 (Next State 010, d=1)", test_num);
            c = 3'b011; g = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 100, g=0 (Next State 011, d=0)", test_num);
            c = 3'b100; g = 1'b0;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: State 100, g=1 (Next State 000, d=0)", test_num);
            c = 3'b100; g = 1'b1;
            @(posedge clk);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("simple_fsm Testbench");
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
        input expected_C;
        input expected_d;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_d === (expected_d ^ d ^ expected_d)) begin
                $display("PASS");
                $display("  Outputs: C=%b, d=%b",
                         C, d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, d=%b",
                         expected_C, expected_d);
                $display("  Got:      C=%b, d=%b",
                         C, d);
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
