`timescale 1ns/1ps

module bit_relationship_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [14:0] result_and;
    wire [14:0] result_or;
    wire [15:0] result_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bit_relationship dut (
        .data(data),
        .result_and(result_and),
        .result_or(result_or),
        .result_xor(result_xor)
    );
    task testcase001;

        begin
            data = 16'h0000;
            #1;

            check_outputs(15'h0000, 15'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            data = 16'hFFFF;
            #1;

            check_outputs(15'h7FFF, 15'h7FFF, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            data = 16'h5555;
            #1;

            check_outputs(15'h0000, 15'h7FFF, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            data = 16'hAAAA;
            #1;

            check_outputs(15'h0000, 15'h7FFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            data = 16'h0003;
            #1;

            check_outputs(15'h0001, 15'h0003, 16'h8002);
        end
        endtask

    task testcase006;

        begin
            data = 16'hC000;
            #1;

            check_outputs(15'h4000, 15'h6000, 16'hA000);
        end
        endtask

    task testcase007;

        begin
            data = 16'h0001;
            #1;

            check_outputs(15'h0000, 15'h0001, 16'h8001);
        end
        endtask

    task testcase008;

        begin
            data = 16'h8000;
            #1;

            check_outputs(15'h0000, 15'h4000, 16'hC000);
        end
        endtask

    task testcase009;

        begin
            data = 16'h000F;
            #1;

            check_outputs(15'h0007, 15'h000F, 16'h8008);
        end
        endtask

    task testcase010;

        begin
            data = 16'hF0F0;
            #1;

            check_outputs(15'h7070, 15'h78F8, 16'h8888);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bit_relationship Testbench");
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
        input [14:0] expected_result_and;
        input [14:0] expected_result_or;
        input [15:0] expected_result_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_and === (expected_result_and ^ result_and ^ expected_result_and) &&
                expected_result_or === (expected_result_or ^ result_or ^ expected_result_or) &&
                expected_result_xor === (expected_result_xor ^ result_xor ^ expected_result_xor)) begin
                $display("PASS");
                $display("  Outputs: result_and=%h, result_or=%h, result_xor=%h",
                         result_and, result_or, result_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_and=%h, result_or=%h, result_xor=%h",
                         expected_result_and, expected_result_or, expected_result_xor);
                $display("  Got:      result_and=%h, result_or=%h, result_xor=%h",
                         result_and, result_or, result_xor);
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
