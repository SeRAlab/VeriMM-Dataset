`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    reg [1:0] z;
    wire [3:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .z(z),
        .r(r)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=0 (r=0)", test_num);
            x = 4'hA; y = 4'h5; z = 2'b00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=1 (r=y)", test_num);
            x = 4'h3; y = 4'hC; z = 2'b01;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=2 (r=x)", test_num);
            x = 4'h7; y = 4'h2; z = 2'b10;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=3 (r=x+y, no overflow)", test_num);
            x = 4'h4; y = 4'h5; z = 2'b11;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=3 (r=x+y, with overflow)", test_num);
            x = 4'hD; y = 4'h5; z = 2'b11;
            #1;

            check_outputs(4'h2);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=0 with different inputs", test_num);
            x = 4'hF; y = 4'hF; z = 2'b00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=1 with different inputs", test_num);
            x = 4'h0; y = 4'hF; z = 2'b01;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=2 with different inputs", test_num);
            x = 4'hB; y = 4'hE; z = 2'b10;
            #1;

            check_outputs(4'hB);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=3 (r=x+y, max sum)", test_num);
            x = 4'hF; y = 4'hF; z = 2'b11;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: z=3 (r=x+y, zero result)", test_num);
            x = 4'h8; y = 4'h8; z = 2'b11;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_r;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%h",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%h",
                         expected_r);
                $display("  Got:      r=%h",
                         r);
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
