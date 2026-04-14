`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] ctrl;
    reg [15:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 16'hA5A5;
            ctrl = 4'd0;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 16'hF0F0;
            ctrl = 4'd1;
            #1;

            check_outputs(16'h0F0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 16'h0001;
            ctrl = 4'd2;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 16'h0001;
            ctrl = 4'd3;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 16'h0001;
            ctrl = 4'd4;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 16'h0002;
            ctrl = 4'd5;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 16'h1234;
            ctrl = 4'd6;
            #1;

            check_outputs(16'h3412);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in = 16'hFFFF;
            ctrl = 4'd7;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            in = 16'h0000;
            ctrl = 4'd8;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            in = 16'hAAAA;
            ctrl = 4'd9;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            in = 16'hFFFE;
            ctrl = 4'd10;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            in = 16'h8000;
            ctrl = 4'd11;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            in = 16'h1234;
            ctrl = 4'd12;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            in = 16'h1234;
            ctrl = 4'd13;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            in = 16'h0000;
            ctrl = 4'd14;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase016;

        begin
            test_num = 16;
            in = 16'h0000;
            ctrl = 4'd15;
            #1;

            check_outputs(16'hAAAA);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
