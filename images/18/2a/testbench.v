`timescale 1ns/1ps

module dot_product_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] vector_a;
    reg [4:0] vector_b;
    wire [9:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dot_product dut (
        .vector_a(vector_a),
        .vector_b(vector_b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero inputs", test_num);
            vector_a = 5'd0;
            vector_b = 5'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero multiplication", test_num);
            vector_a = 5'd31;
            vector_b = 5'd0;
            #1;

            check_outputs(10'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Unit multiplication", test_num);
            vector_a = 5'd1;
            vector_b = 5'd1;
            #1;

            check_outputs(10'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Identity multiplication", test_num);
            vector_a = 5'd25;
            vector_b = 5'd1;
            #1;

            check_outputs(10'd25);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Maximum values (31 * 31)", test_num);
            vector_a = 5'd31;
            vector_b = 5'd31;
            #1;

            check_outputs(10'd961);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Power of 2 (16 * 16)", test_num);
            vector_a = 5'd16;
            vector_b = 5'd16;
            #1;

            check_outputs(10'd256);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Standard multiplication (12 * 7)", test_num);
            vector_a = 5'd12;
            vector_b = 5'd7;
            #1;

            check_outputs(10'd84);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Arbitrary values (19 * 3)", test_num);
            vector_a = 5'd19;
            vector_b = 5'd3;
            #1;

            check_outputs(10'd57);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dot_product Testbench");
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
        input [9:0] expected_result;
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
