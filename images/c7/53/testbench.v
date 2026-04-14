`timescale 1ns/1ps

module bitwise_or_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] X;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_or dut (
        .A(A),
        .B(B),
        .X(X)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros (00 | 00)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (FF | FF)", test_num);
            A = 8'hFF;
            B = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (AA | 55)", test_num);
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Nibble Masking (F0 | 0F)", test_num);
            A = 8'hF0;
            B = 8'h0F;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A or 0 (DE | 00)", test_num);
            A = 8'hDE;
            B = 8'h00;
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 0 or B (00 | AD)", test_num);
            A = 8'h00;
            B = 8'hAD;
            #1;

            check_outputs(8'hAD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overlapping Bits (CC | 66)", test_num);

            A = 8'hCC;
            B = 8'h66;
            #1;

            check_outputs(8'hEE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 Bits (80 | 01)", test_num);
            A = 8'h80;
            B = 8'h01;
            #1;

            check_outputs(8'h81);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Values (01 | 02)", test_num);
            A = 8'h01;
            B = 8'h02;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex Mix (12 | 34)", test_num);

            A = 8'h12;
            B = 8'h34;
            #1;

            check_outputs(8'h36);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_or Testbench");
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
