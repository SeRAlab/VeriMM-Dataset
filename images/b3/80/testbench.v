`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] final_output;
    wire overflow;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .final_output(final_output),
        .overflow(overflow),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Small positive product", test_num);
            a = 8'd5; b = 8'd10;
            #1;

            check_outputs(8'h32, 1'b0, 8'h32);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Multiplication by zero", test_num);
            a = 8'd0; b = 8'd255;
            #1;

            check_outputs(8'h00, 1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Large product, no addition overflow", test_num);
            a = 8'hFF; b = 8'hFF;
            #1;

            check_outputs(8'hFF, 1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Positive addition overflow (Pos+Pos=Neg)", test_num);
            a = 8'd98; b = 8'd168;
            #1;

            check_outputs(8'h90, 1'b1, 8'h90);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Negative addition overflow (Neg+Neg=Pos)", test_num);
            a = 8'd167; b = 8'd197;
            #1;

            check_outputs(8'h03, 1'b1, 8'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed signs addition resulting in 0x80", test_num);
            a = 8'd128; b = 8'd1;
            #1;

            check_outputs(8'h80, 1'b0, 8'h80);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Product results in carry to Upper byte", test_num);
            a = 8'd2; b = 8'd128;
            #1;

            check_outputs(8'h01, 1'b0, 8'h01);
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
        input [7:0] expected_final_output;
        input expected_overflow;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h, overflow=%b, s=%h",
                         final_output, overflow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h, overflow=%b, s=%h",
                         expected_final_output, expected_overflow, expected_s);
                $display("  Got:      final_output=%h, overflow=%b, s=%h",
                         final_output, overflow, s);
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
