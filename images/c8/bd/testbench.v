`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg sel_b1;
    reg sel_b2;
    wire out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_always(out_always)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: sel_b1=0, sel_b2=0 (Should select a)", test_num);
        a = 1'b0; b = 1'b1; sel_b1 = 1'b0; sel_b2 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: sel_b1=0, sel_b2=0 (Should select a)", test_num);
        a = 1'b1; b = 1'b0; sel_b1 = 1'b0; sel_b2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: sel_b1=0, sel_b2=1 (Should select a)", test_num);
        a = 1'b0; b = 1'b1; sel_b1 = 1'b0; sel_b2 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: sel_b1=0, sel_b2=1 (Should select a)", test_num);
        a = 1'b1; b = 1'b0; sel_b1 = 1'b0; sel_b2 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: sel_b1=1, sel_b2=0 (Should select a)", test_num);
        a = 1'b0; b = 1'b1; sel_b1 = 1'b1; sel_b2 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: sel_b1=1, sel_b2=0 (Should select a)", test_num);
        a = 1'b1; b = 1'b0; sel_b1 = 1'b1; sel_b2 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: sel_b1=1, sel_b2=1 (Should select b)", test_num);
        a = 1'b0; b = 1'b1; sel_b1 = 1'b1; sel_b2 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: sel_b1=1, sel_b2=1 (Should select b)", test_num);
        a = 1'b1; b = 1'b0; sel_b1 = 1'b1; sel_b2 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: sel_b1=1, sel_b2=1, both inputs same (Should select b)", test_num);
        a = 1'b1; b = 1'b1; sel_b1 = 1'b1; sel_b2 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: sel_b1=0, sel_b2=0, both inputs same (Should select a)", test_num);
        a = 1'b0; b = 1'b0; sel_b1 = 1'b0; sel_b2 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1 Testbench");
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
        input expected_out_always;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_always === (expected_out_always ^ out_always ^ expected_out_always)) begin
                $display("PASS");
                $display("  Outputs: out_always=%b",
                         out_always);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_always=%b",
                         expected_out_always);
                $display("  Got:      out_always=%b",
                         out_always);
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
