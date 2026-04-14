`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0] op;
    wire [15:0] result;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 16'h0005; B = 16'h000A; op = 3'd0;
            #1;

            check_outputs(16'h000F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 16'hFFFF; B = 16'h0001; op = 3'd0;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 16'h0020; B = 16'h0005; op = 3'd1;
            #1;

            check_outputs(16'h001B, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 16'h000A; B = 16'h000A; op = 3'd1;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 16'h0000; B = 16'h0001; op = 3'd1;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 16'hAAAA; B = 16'h5555; op = 3'd2;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 16'hF0F0; B = 16'hFFFF; op = 3'd2;
            #1;

            check_outputs(16'hF0F0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 16'hAAAA; B = 16'h5555; op = 3'd3;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 16'h0000; B = 16'h0000; op = 3'd3;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 16'h1234; B = 16'h1234; op = 3'd4;
            #1;

            check_outputs(16'h0000, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            A = 16'h00FF; B = 16'hFF00; op = 3'd4;
            #1;

            check_outputs(16'hFFFF, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [15:0] expected_result;
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result) &&
                expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: result=%h, zero=%b",
                         result, zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h, zero=%b",
                         expected_result, expected_zero);
                $display("  Got:      result=%h, zero=%b",
                         result, zero);
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
