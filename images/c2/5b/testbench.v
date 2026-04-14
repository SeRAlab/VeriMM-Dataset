`timescale 1ns/1ps

module mux_2to1_behavioral_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg sel_a;
    reg sel_b1;
    reg sel_b2;
    wire out_mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_behavioral dut (
        .a(a),
        .b(b),
        .sel_a(sel_a),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_mux(out_mux)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 1; b = 0; sel_a = 1; sel_b1 = 0; sel_b2 = 0;
            $display("Test %0d: sel_a=1, a=1 -> Expect out_mux=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 0; b = 1; sel_a = 1; sel_b1 = 1; sel_b2 = 1;
            $display("Test %0d: sel_a=1, a=0 -> Expect out_mux=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 0; b = 1; sel_a = 0; sel_b1 = 0; sel_b2 = 0;
            $display("Test %0d: sel_a=0, sel_b1=0, sel_b2=0, b=1 -> Expect out_mux=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 1; b = 0; sel_a = 0; sel_b1 = 0; sel_b2 = 0;
            $display("Test %0d: sel_a=0, sel_b1=0, sel_b2=0, b=0 -> Expect out_mux=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 0; b = 1; sel_a = 0; sel_b1 = 1; sel_b2 = 0;
            $display("Test %0d: sel_a=0, sel_b1=1 (Invalid B) -> Expect out_mux=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 0; b = 1; sel_a = 0; sel_b1 = 0; sel_b2 = 1;
            $display("Test %0d: sel_a=0, sel_b2=1 (Invalid B) -> Expect out_mux=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 0; b = 1; sel_a = 0; sel_b1 = 1; sel_b2 = 1;
            $display("Test %0d: sel_a=0, sel_b1=1, sel_b2=1 -> Expect out_mux=0", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 1; b = 0; sel_a = 1; sel_b1 = 0; sel_b2 = 0;
            $display("Test %0d: Priority Check (sel_a=1 takes precedence) -> Expect out_mux=1", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_behavioral Testbench");
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
        input expected_out_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_mux === (expected_out_mux ^ out_mux ^ expected_out_mux)) begin
                $display("PASS");
                $display("  Outputs: out_mux=%b",
                         out_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_mux=%b",
                         expected_out_mux);
                $display("  Got:      out_mux=%b",
                         out_mux);
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
