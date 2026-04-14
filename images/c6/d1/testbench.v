`timescale 1ns/1ps

module mux_2to1_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg sel;
    wire out_always;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .out_always(out_always)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 1'b0;
        b = 1'b0;
        sel = 1'b0;
        $display("Test Case 001: Select A (0), A=0, B=0");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 1'b1;
        b = 1'b0;
        sel = 1'b0;
        $display("Test Case 002: Select A (0), A=1, B=0");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 1'b0;
        b = 1'b1;
        sel = 1'b0;
        $display("Test Case 003: Select A (0), A=0, B=1");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 1'b1;
        b = 1'b1;
        sel = 1'b0;
        $display("Test Case 004: Select A (0), A=1, B=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 1'b0;
        b = 1'b0;
        sel = 1'b1;
        $display("Test Case 005: Select B (1), A=0, B=0");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 1'b1;
        b = 1'b0;
        sel = 1'b1;
        $display("Test Case 006: Select B (1), A=1, B=0");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 1'b0;
        b = 1'b1;
        sel = 1'b1;
        $display("Test Case 007: Select B (1), A=0, B=1");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 1'b1;
        b = 1'b1;
        sel = 1'b1;
        $display("Test Case 008: Select B (1), A=1, B=1");
        #1;

        check_outputs(1'b1);
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
