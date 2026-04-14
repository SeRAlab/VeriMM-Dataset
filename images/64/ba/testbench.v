`timescale 1ns/1ps

module logic_unit_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire u_pos;
    wire u_sop;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_unit dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .u_pos(u_pos),
        .u_sop(u_sop)
    );
    task testcase001;

        begin
            test_num = 1;
            {a, b, c, d} = 4'b0000;
            $display("Test %0d: Input 0 (0000)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            {a, b, c, d} = 4'b0010;
            $display("Test %0d: Input 2 (0010)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            {a, b, c, d} = 4'b0100;
            $display("Test %0d: Input 4 (0100)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            {a, b, c, d} = 4'b0111;
            $display("Test %0d: Input 7 (0111)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            {a, b, c, d} = 4'b1000;
            $display("Test %0d: Input 8 (1000)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            {a, b, c, d} = 4'b1010;
            $display("Test %0d: Input 10 (1010)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            {a, b, c, d} = 4'b1011;
            $display("Test %0d: Input 11 (1011)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            {a, b, c, d} = 4'b1101;
            $display("Test %0d: Input 13 (1101)", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            {a, b, c, d} = 4'b1110;
            $display("Test %0d: Input 14 (1110)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            {a, b, c, d} = 4'b1111;
            $display("Test %0d: Input 15 (1111)", test_num);
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
        $display("logic_unit Testbench");
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
        input expected_u_pos;
        input expected_u_sop;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_u_pos === (expected_u_pos ^ u_pos ^ expected_u_pos) &&
                expected_u_sop === (expected_u_sop ^ u_sop ^ expected_u_sop)) begin
                $display("PASS");
                $display("  Outputs: u_pos=%b, u_sop=%b",
                         u_pos, u_sop);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: u_pos=%b, u_sop=%b",
                         expected_u_pos, expected_u_sop);
                $display("  Got:      u_pos=%b, u_sop=%b",
                         u_pos, u_sop);
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
