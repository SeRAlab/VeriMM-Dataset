`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire carry;
    wire overflow;
    wire [15:0] sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .carry(carry),
        .overflow(overflow),
        .sub(sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 100 - 50", test_num);
            a = 16'd100;
            b = 16'd50;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0032);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 50 - 100 (Unsigned borrow)", test_num);
            a = 16'd50;
            b = 16'd100;

            #1;


            check_outputs(1'b1, 1'b0, 16'hFFCE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 1000 - 1000", test_num);
            a = 16'd1000;
            b = 16'd1000;

            #1;


            check_outputs(1'b0, 1'b0, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 20000 - (-20000) (Signed Overflow)", test_num);
            a = 16'd20000;
            b = 16'hB1E0;




            #1;





            check_outputs(1'b1, 1'b1, 16'h9C40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -20000 - 20000 (Signed Overflow)", test_num);
            a = 16'hB1E0;
            b = 16'd20000;




            #1;





            check_outputs(1'b0, 1'b1, 16'h63C0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -32768 - 1", test_num);
            a = 16'h8000;
            b = 16'h0001;



            #1;




            check_outputs(1'b0, 1'b1, 16'h7FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 32767 - (-1)", test_num);
            a = 16'h7FFF;
            b = 16'hFFFF;



            #1;




            check_outputs(1'b1, 1'b1, 16'h8000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -32767 - 1", test_num);
            a = 16'h8001;
            b = 16'h0001;

            #1;


            check_outputs(1'b0, 1'b0, 16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 32766 - (-1)", test_num);
            a = 16'h7FFE;
            b = 16'hFFFF;



            #1;




            check_outputs(1'b1, 1'b0, 16'h7FFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: -100 - (-50)", test_num);
            a = 16'hFF9C;
            b = 16'hFFCE;



            #1;




            check_outputs(1'b1, 1'b0, 16'hFFCE);
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
        input expected_carry;
        input expected_overflow;
        input [15:0] expected_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sub === (expected_sub ^ sub ^ expected_sub)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, overflow=%b, sub=%h",
                         carry, overflow, sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, overflow=%b, sub=%h",
                         expected_carry, expected_overflow, expected_sub);
                $display("  Got:      carry=%b, overflow=%b, sub=%h",
                         carry, overflow, sub);
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
