`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0000; b = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h0100; b = 16'h0100;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'h0100; b = 16'hFF00;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'hFE00; b = 16'hFE00;
            #1;

            check_outputs(32'h00040000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'h0080; b = 16'h0080;
            #1;

            check_outputs(32'h00004000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h7FFF; b = 16'h0100;
            #1;

            check_outputs(32'h00007FFF00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 16'h0001; b = 16'h0001;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 16'h0A80; b = 16'hFAD0;
            #1;

            check_outputs(32'hFFC92000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 16'h8000; b = 16'hFF00;
            #1;

            check_outputs(32'h00800000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 16'h7FFF; b = 16'h7FFF;
            #1;

            check_outputs(32'h3FFF0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
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
        input [31:0] expected_result;
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
