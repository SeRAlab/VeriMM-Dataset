`timescale 1ns/1ps

module mux_2_to_1_tb;

    // Testbench signals (combinational circuit)
    reg in_0;
    reg in_1;
    reg select;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2_to_1 dut (
        .in_0(in_0),
        .in_1(in_1),
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Select in_0, in_0=0, in_1=0");
        select = 1'b0;
        in_0 = 1'b0;
        in_1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Select in_0, in_0=1, in_1=0");
        select = 1'b0;
        in_0 = 1'b1;
        in_1 = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Select in_0, in_0=0, in_1=1");
        select = 1'b0;
        in_0 = 1'b0;
        in_1 = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Select in_0, in_0=1, in_1=1");
        select = 1'b0;
        in_0 = 1'b1;
        in_1 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Select in_1, in_0=0, in_1=0");
        select = 1'b1;
        in_0 = 1'b0;
        in_1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Select in_1, in_0=1, in_1=0");
        select = 1'b1;
        in_0 = 1'b1;
        in_1 = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Select in_1, in_0=0, in_1=1");
        select = 1'b1;
        in_0 = 1'b0;
        in_1 = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Select in_1, in_0=1, in_1=1");
        select = 1'b1;
        in_0 = 1'b1;
        in_1 = 1'b1;
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
        $display("mux_2_to_1 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
