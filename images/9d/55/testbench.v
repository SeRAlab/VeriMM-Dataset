`timescale 1ns/1ps

module mux2to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data0;
    reg [3:0] data1;
    reg sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1 dut (
        .data0(data0),
        .data1(data1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Select data0 (4'hA)");
            data0 = 4'hA;
            data1 = 4'h5;
            sel = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Select data1 (4'h5)");
            data0 = 4'hA;
            data1 = 4'h5;
            sel = 1;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Select data0 (All Zeros)");
            data0 = 4'b0000;
            data1 = 4'b1111;
            sel = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Select data1 (All Ones)");
            data0 = 4'b0000;
            data1 = 4'b1111;
            sel = 1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Boundary value check - Select data0");
            data0 = 4'h9;
            data1 = 4'h6;
            sel = 0;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Boundary value check - Select data1");
            data0 = 4'h9;
            data1 = 4'h6;
            sel = 1;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Toggle data while sel is constant (sel=0)");
            data1 = 4'hE;
            sel = 0;
            data0 = 4'h3;
            #1;
            data0 = 4'h7;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: Toggle data while sel is constant (sel=1)");
            data0 = 4'h3;
            sel = 1;
            data1 = 4'hB;
            #1;
            data1 = 4'hD;
            #1;

            check_outputs(4'hD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux2to1 Testbench");
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
        input [3:0] expected_out;
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
