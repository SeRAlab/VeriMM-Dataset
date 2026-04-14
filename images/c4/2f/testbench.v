`timescale 1ns/1ps

module addsub_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg sel;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    addsub dut (
        .A(A),
        .B(B),
        .sel(sel),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition No Carry (2 + 3)", test_num);
        A = 4'd2;
        B = 4'd3;
        sel = 1'b0;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition With Carry (10 + 10)", test_num);
        A = 4'd10;
        B = 4'd10;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition Max Values (15 + 15)", test_num);
        A = 4'd15;
        B = 4'd15;
        sel = 1'b0;
        #1;

        check_outputs(1'b1, 4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction No Borrow (10 - 4)", test_num);
        A = 4'd10;
        B = 4'd4;
        sel = 1'b1;
        #1;

        check_outputs(1'b0, 4'd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Result Zero (7 - 7)", test_num);
        A = 4'd7;
        B = 4'd7;
        sel = 1'b1;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction With Borrow (4 - 10)", test_num);
        A = 4'd4;
        B = 4'd10;
        sel = 1'b1;
        #1;

        check_outputs(1'b1, 4'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Subtraction Minimal (0 - 1)", test_num);
        A = 4'd0;
        B = 4'd1;
        sel = 1'b1;
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle Mode (8 +/- 2)", test_num);
        A = 4'd8;
        B = 4'd2;


        sel = 1'b0;
        #1;

        check_outputs(1'b0, 4'd10);


        sel = 1'b1;
        #1;

        check_outputs(1'b0, 4'd6);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("addsub Testbench");
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
