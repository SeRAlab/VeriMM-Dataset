`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    reg [1:0] sel;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Select A (sel=00), expect y=0", test_num);
            a = 0; b = 1; c = 1; d = 1; sel = 2'b00;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select A (sel=00), expect y=1", test_num);
            a = 1; b = 0; c = 0; d = 0; sel = 2'b00;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select B (sel=01), expect y=0", test_num);
            a = 1; b = 0; c = 1; d = 1; sel = 2'b01;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select B (sel=01), expect y=1", test_num);
            a = 0; b = 1; c = 0; d = 0; sel = 2'b01;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select C (sel=10), expect y=0", test_num);
            a = 1; b = 1; c = 0; d = 1; sel = 2'b10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select C (sel=10), expect y=1", test_num);
            a = 0; b = 0; c = 1; d = 0; sel = 2'b10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select D (sel=11), expect y=0", test_num);
            a = 1; b = 1; c = 1; d = 0; sel = 2'b11;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select D (sel=11), expect y=1", test_num);
            a = 0; b = 0; c = 0; d = 1; sel = 2'b11;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Check data isolation (sel=01, change A/C/D)", test_num);
            a = 1; b = 1; c = 1; d = 1; sel = 2'b01;
            #5;
            a = 0; c = 0; d = 0;
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
        $display("mux4to1 Testbench");
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
