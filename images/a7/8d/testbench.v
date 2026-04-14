`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c;
    reg [3:0] g;
    reg [3:0] p;
    wire C0;
    wire C1;
    wire C2;
    wire C3;
    wire G;
    wire P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .g(g),
        .p(p),
        .C0(C0),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .G(G),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All signals zero", test_num);
            g = 4'b0000;
            p = 4'b0000;
            c = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Propagate chain with carry-in", test_num);
            g = 4'b0000;
            p = 4'b1111;
            c = 1'b1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High bit generate only", test_num);
            g = 4'b1000;
            p = 4'b0000;
            c = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Low bit generate propagates to all stages", test_num);
            g = 4'b0001;
            p = 4'b1110;
            c = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Middle bit generate and partial propagate", test_num);
            g = 4'b0100;
            p = 4'b1011;
            c = 1'b0;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry-in blocked by zero propagate bit", test_num);
            g = 4'b0000;
            p = 4'b1101;
            c = 1'b1;

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits generate", test_num);
            g = 4'b1111;
            p = 4'b0000;
            c = 1'b0;

            #1;


            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed generates and propagates", test_num);
            g = 4'b0010;
            p = 4'b1100;
            c = 1'b1;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0);
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
        input expected_C0;
        input expected_C1;
        input expected_C2;
        input expected_C3;
        input expected_G;
        input expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C0 === (expected_C0 ^ C0 ^ expected_C0) &&
                expected_C1 === (expected_C1 ^ C1 ^ expected_C1) &&
                expected_C2 === (expected_C2 ^ C2 ^ expected_C2) &&
                expected_C3 === (expected_C3 ^ C3 ^ expected_C3) &&
                expected_G === (expected_G ^ G ^ expected_G) &&
                expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: C0=%b, C1=%b, C2=%b, C3=%b, G=%b, P=%b",
                         C0, C1, C2, C3, G, P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C0=%b, C1=%b, C2=%b, C3=%b, G=%b, P=%b",
                         expected_C0, expected_C1, expected_C2, expected_C3, expected_G, expected_P);
                $display("  Got:      C0=%b, C1=%b, C2=%b, C3=%b, G=%b, P=%b",
                         C0, C1, C2, C3, G, P);
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
