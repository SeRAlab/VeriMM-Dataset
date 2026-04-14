`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] B_in;
    reg [7:0] G_in;
    reg [7:0] R_in;
    wire [7:0] B_out;
    wire [7:0] G_out;
    wire [7:0] R_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .B_in(B_in),
        .G_in(G_in),
        .R_in(R_in),
        .B_out(B_out),
        .G_out(G_out),
        .R_out(R_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simple values no wrap-around", test_num);
            R_in = 8'd100;
            G_in = 8'd40;
            B_in = 8'd60;



            #1;




            check_outputs(8'hD8, 8'h64, 8'h3C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All zero inputs", test_num);
            R_in = 8'd0;
            G_in = 8'd0;
            B_in = 8'd0;



            #1;




            check_outputs(8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All maximum inputs (255)", test_num);
            R_in = 8'd255;
            G_in = 8'd255;
            B_in = 8'd255;



            #1;




            check_outputs(8'h00, 8'hFE, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Red component underflow", test_num);
            R_in = 8'd10;
            G_in = 8'd20;
            B_in = 8'd30;



            #1;




            check_outputs(8'h14, 8'h32, 8'hF6);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Green component overflow", test_num);
            R_in = 8'd50;
            G_in = 8'd200;
            B_in = 8'd100;



            #1;




            check_outputs(8'h32, 8'h2C, 8'h6A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Blue component underflow", test_num);
            R_in = 8'd255;
            G_in = 8'd0;
            B_in = 8'd10;



            #1;




            check_outputs(8'h0B, 8'h0A, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Extreme cross-channel subtraction", test_num);
            R_in = 8'd1;
            G_in = 8'd255;
            B_in = 8'd0;



            #1;




            check_outputs(8'hFF, 8'hFF, 8'h02);
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
        input [7:0] expected_B_out;
        input [7:0] expected_G_out;
        input [7:0] expected_R_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B_out === (expected_B_out ^ B_out ^ expected_B_out) &&
                expected_G_out === (expected_G_out ^ G_out ^ expected_G_out) &&
                expected_R_out === (expected_R_out ^ R_out ^ expected_R_out)) begin
                $display("PASS");
                $display("  Outputs: B_out=%h, G_out=%h, R_out=%h",
                         B_out, G_out, R_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B_out=%h, G_out=%h, R_out=%h",
                         expected_B_out, expected_G_out, expected_R_out);
                $display("  Got:      B_out=%h, G_out=%h, R_out=%h",
                         B_out, G_out, R_out);
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
