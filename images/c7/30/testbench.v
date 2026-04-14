`timescale 1ns/1ps

module mux_2to1_behavioral_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg s;
    wire [3:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_behavioral dut (
        .a(a),
        .b(b),
        .s(s),
        .mux_out(mux_out)
    );
    task testcase001;

        begin
            $display("\nTest Case 001: Select A (s=0)");
            a = 4'b1010;
            b = 4'b0101;
            s = 1'b0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: Select B (s=1)");
            a = 4'b1010;
            b = 4'b0101;
            s = 1'b1;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Select A with All Zeros/Ones");
            a = 4'b0000;
            b = 4'b1111;
            s = 1'b0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: Select B with All Zeros/Ones");
            a = 4'b0000;
            b = 4'b1111;
            s = 1'b1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Select A with high nibble values");
            a = 4'hF;
            b = 4'h0;
            s = 1'b0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("\nTest Case 006: Select B with high nibble values");
            a = 4'hF;
            b = 4'h0;
            s = 1'b1;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("\nTest Case 007: Toggle A while s=0");
            a = 4'hC;
            b = 4'h3;
            s = 1'b0;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            $display("\nTest Case 008: Toggle B while s=1");
            a = 4'hC;
            b = 4'h3;
            s = 1'b1;
            #1;

            check_outputs(4'h3);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_behavioral Testbench");
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
        input [3:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: mux_out=%h",
                         mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mux_out=%h",
                         expected_mux_out);
                $display("  Got:      mux_out=%h",
                         mux_out);
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
