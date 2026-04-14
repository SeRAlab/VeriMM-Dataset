`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] in1;
    reg [3:0] in2;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equality (True) - ctrl=00, in1=10, in2=10", test_num);
            ctrl = 2'b00;
            in1 = 4'd10;
            in2 = 4'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Equality (False) - ctrl=00, in1=10, in2=5", test_num);
            ctrl = 2'b00;
            in1 = 4'd10;
            in2 = 4'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Greater Than (True) - ctrl=01, in1=12, in2=4", test_num);
            ctrl = 2'b01;
            in1 = 4'd12;
            in2 = 4'd4;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Greater Than (False) - ctrl=01, in1=4, in2=12", test_num);
            ctrl = 2'b01;
            in1 = 4'd4;
            in2 = 4'd12;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Greater Than (False, Equal) - ctrl=01, in1=8, in2=8", test_num);
            ctrl = 2'b01;
            in1 = 4'd8;
            in2 = 4'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Less Than (True) - ctrl=10, in1=2, in2=9", test_num);
            ctrl = 2'b10;
            in1 = 4'd2;
            in2 = 4'd9;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Less Than (False) - ctrl=10, in1=9, in2=2", test_num);
            ctrl = 2'b10;
            in1 = 4'd9;
            in2 = 4'd2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Less Than (False, Equal) - ctrl=10, in1=6, in2=6", test_num);
            ctrl = 2'b10;
            in1 = 4'd6;
            in2 = 4'd6;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Default Case - ctrl=11, in1=15, in2=15", test_num);
            ctrl = 2'b11;
            in1 = 4'd15;
            in2 = 4'd15;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Equality - ctrl=00, in1=15, in2=15", test_num);
            ctrl = 2'b00;
            in1 = 4'hF;
            in2 = 4'hF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Equality - ctrl=00, in1=0, in2=0", test_num);
            ctrl = 2'b00;
            in1 = 4'h0;
            in2 = 4'h0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary GT - ctrl=01, in1=15, in2=0", test_num);
            ctrl = 2'b01;
            in1 = 4'hF;
            in2 = 4'h0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary LT - ctrl=10, in1=0, in2=15", test_num);
            ctrl = 2'b10;
            in1 = 4'h0;
            in2 = 4'hF;
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
