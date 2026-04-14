`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [21:0] i_a;
    wire [7:0] o_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_a(i_a),
        .o_b(o_b)
    );
    task testcase001;

        begin
            i_a = {1'b0, 5'd10, 16'hFFFF};
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            i_a = {1'b0, 5'd14, 16'hFFFF};
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            i_a = {1'b0, 5'd15, 16'h0000};
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            i_a = {1'b0, 5'd15, 16'hFFFF};
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase005;

        begin
            i_a = {1'b0, 5'd16, 16'h0000};
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            i_a = {1'b0, 5'd16, 16'h8000};
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase007;

        begin
            i_a = {1'b0, 5'd19, 16'h4000};
            #1;

            check_outputs(8'h14);
        end
        endtask

    task testcase008;

        begin
            i_a = {1'b0, 5'd22, 16'h0000};
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase009;

        begin
            i_a = {1'b0, 5'd22, 16'hFE00};
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            i_a = {1'b0, 5'd23, 16'h0000};
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase011;

        begin
            i_a = {1'b0, 5'd31, 16'h0000};
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase012;

        begin
            i_a = {1'b1, 5'd15, 16'h0000};


            #1;



            check_outputs(8'h01);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_o_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_b === (expected_o_b ^ o_b ^ expected_o_b)) begin
                $display("PASS");
                $display("  Outputs: o_b=%h",
                         o_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_b=%h",
                         expected_o_b);
                $display("  Got:      o_b=%h",
                         o_b);
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
