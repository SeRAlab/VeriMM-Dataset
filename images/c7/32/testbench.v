`timescale 1ns/1ps

module MUX_2x1_8_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg SEL;
    wire [7:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    MUX_2x1_8 dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .X(X)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: SEL=0, Select Input A", test_num);
            A = 8'hAA;
            B = 8'h55;
            SEL = 1'b0;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: SEL=1, Select Input B", test_num);
            A = 8'hAA;
            B = 8'h55;
            SEL = 1'b1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: All Zeros, SEL=0", test_num);
            A = 8'h00;
            B = 8'hFF;
            SEL = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: All Ones, SEL=1", test_num);
            A = 8'h00;
            B = 8'hFF;
            SEL = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Arbitrary Values, SEL=0", test_num);
            A = 8'h12;
            B = 8'h34;
            SEL = 1'b0;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Arbitrary Values, SEL=1", test_num);
            A = 8'h12;
            B = 8'h34;
            SEL = 1'b1;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Edge Case All Ones A, SEL=0", test_num);
            A = 8'hFF;
            B = 8'hAA;
            SEL = 1'b0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Edge Case All Zeros B, SEL=1", test_num);
            A = 8'h55;
            B = 8'h00;
            SEL = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("MUX_2x1_8 Testbench");
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
        input [7:0] expected_X;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_X === (expected_X ^ X ^ expected_X)) begin
                $display("PASS");
                $display("  Outputs: X=%h",
                         X);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: X=%h",
                         expected_X);
                $display("  Got:      X=%h",
                         X);
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
