`timescale 1ns/1ps

module calculator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    calculator dut (
        .A(A),
        .B(B),
        .sel(sel),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'd15;
            B = 8'd10;
            sel = 1'b0;
            $display("Test %0d: Basic Addition (15 + 10)", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'd50;
            B = 8'd20;
            sel = 1'b1;
            $display("Test %0d: Basic Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hFF;
            B = 8'h01;
            sel = 1'b0;
            $display("Test %0d: Addition Overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'h00;
            B = 8'h01;
            sel = 1'b1;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'd128;
            B = 8'd128;
            sel = 1'b1;
            $display("Test %0d: Subtraction resulting in zero (128 - 128)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'd0;
            B = 8'd0;
            sel = 1'b0;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'hAA;
            B = 8'h55;
            sel = 1'b0;
            $display("Test %0d: Pattern Addition (0xAA + 0x55)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hFF;
            B = 8'hFF;
            sel = 1'b0;
            $display("Test %0d: Maximum Values Addition (255 + 255)", test_num);
            #1;

            check_outputs(8'hFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("calculator Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
