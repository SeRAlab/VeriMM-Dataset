`timescale 1ns/1ps

module carry_skip_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Cin;
    wire Cout;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_skip_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition (5 + 10, Cin=0)", test_num);
            A = 8'h05;
            B = 8'h0A;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in only (0 + 0, Cin=1)", test_num);
            A = 8'h00;
            B = 8'h00;
            Cin = 1'b1;
            #1;

            check_outputs(1'b0, 8'h01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum sum without Cout (127 + 128)", test_num);
            A = 8'd127;
            B = 8'd128;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate Carry Out (255 + 1)", test_num);
            A = 8'hFF;
            B = 8'h01;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Skip Logic - Propagate condition on all bits (AA + 55, Cin=0)", test_num);

            A = 8'hAA;
            B = 8'h55;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Skip Logic - Propagate carry through the skip path (AA + 55, Cin=1)", test_num);

            A = 8'hAA;
            B = 8'h55;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full addition with carry-out and carry-in (255 + 255, Cin=1)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern 1 (0x3C + 0xC3, Cin=0)", test_num);
            A = 8'h3C;
            B = 8'hC3;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry skip within internal blocks (0x0F + 0x01, Cin=0)", test_num);
            A = 8'h0F;
            B = 8'h01;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs", test_num);
            A = 8'h00;
            B = 8'h00;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_skip_adder Testbench");
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
        input expected_Cout;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
