`timescale 1ns/1ps

module mux_16to1_tb;

    // Testbench signals (combinational circuit)
    reg a0;
    reg a1;
    reg a10;
    reg a11;
    reg a12;
    reg a13;
    reg a14;
    reg a15;
    reg a2;
    reg a3;
    reg a4;
    reg a5;
    reg a6;
    reg a7;
    reg a8;
    reg a9;
    reg [3:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16to1 dut (
        .a0(a0),
        .a1(a1),
        .a10(a10),
        .a11(a11),
        .a12(a12),
        .a13(a13),
        .a14(a14),
        .a15(a15),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .a8(a8),
        .a9(a9),
        .sel(sel),
        .y(y)
    );
    task clear_inputs;

        begin
            a0 = 0; a1 = 0; a2 = 0; a3 = 0;
            a4 = 0; a5 = 0; a6 = 0; a7 = 0;
            a8 = 0; a9 = 0; a10 = 0; a11 = 0;
            a12 = 0; a13 = 0; a14 = 0; a15 = 0;
            sel = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Selecting a0 = 1", test_num);
            clear_inputs();
            a0 = 1'b1;
            sel = 4'd0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Selecting a1 = 1", test_num);
            clear_inputs();
            a1 = 1'b1;
            sel = 4'd1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Selecting a7 = 1", test_num);
            clear_inputs();
            a7 = 1'b1;
            sel = 4'd7;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Selecting a8 = 1", test_num);
            clear_inputs();
            a8 = 1'b1;
            sel = 4'd8;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Selecting a15 = 1", test_num);
            clear_inputs();
            a15 = 1'b1;
            sel = 4'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Selecting a4 = 0 while others are 1", test_num);
            a0 = 1; a1 = 1; a2 = 1; a3 = 1;
            a4 = 0; a5 = 1; a6 = 1; a7 = 1;
            a8 = 1; a9 = 1; a10 = 1; a11 = 1;
            a12 = 1; a13 = 1; a14 = 1; a15 = 1;
            sel = 4'd4;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Selecting a10 = 1", test_num);
            clear_inputs();
            a10 = 1'b1;
            sel = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Selecting a12 = 1", test_num);
            clear_inputs();
            a12 = 1'b1;
            sel = 4'd12;
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
        $display("mux_16to1 Testbench");
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
