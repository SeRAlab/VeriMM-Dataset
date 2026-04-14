`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] amt;
    reg [7:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amt(amt),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=00, amt=0", test_num);
            in = 8'h00;
            amt = 4'd0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=00, amt=15", test_num);
            in = 8'h00;
            amt = 4'd15;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=FF, amt=0", test_num);
            in = 8'hFF;
            amt = 4'd0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=01, amt=1", test_num);
            in = 8'h01;
            amt = 4'd1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=A5, amt=4", test_num);
            in = 8'hA5;
            amt = 4'd4;
            #1;

            check_outputs(16'h0A50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=5A, amt=8", test_num);
            in = 8'h5A;
            amt = 4'd8;
            #1;

            check_outputs(16'h5A00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=FF, amt=8", test_num);
            in = 8'hFF;
            amt = 4'd8;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=A5, amt=12", test_num);
            in = 8'hA5;
            amt = 4'd12;

            #1;


            check_outputs(16'h5000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=01, amt=15", test_num);
            in = 8'h01;
            amt = 4'd15;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=03, amt=15", test_num);
            in = 8'h03;
            amt = 4'd15;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=F0, amt=4", test_num);
            in = 8'hF0;
            amt = 4'd4;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: in=AA, amt=2", test_num);
            in = 8'hAA;
            amt = 4'd2;

            #1;


            check_outputs(16'h02A8);
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
