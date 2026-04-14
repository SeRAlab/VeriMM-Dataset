`timescale 1ns/1ps

module mux_4to1_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [1:0] sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1_4bit dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Test Case 001: Select in0 with value 4'hA");
            in0 = 4'hA;
            in1 = 4'h5;
            in2 = 4'h0;
            in3 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Select in1 with value 4'h5");
            in0 = 4'hA;
            in1 = 4'h5;
            in2 = 4'h0;
            in3 = 4'hF;
            sel = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Select in2 with value 4'h0");
            in0 = 4'hA;
            in1 = 4'h5;
            in2 = 4'h0;
            in3 = 4'hF;
            sel = 2'b10;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Select in3 with value 4'hF");
            in0 = 4'hA;
            in1 = 4'h5;
            in2 = 4'h0;
            in3 = 4'hF;
            sel = 2'b11;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Boundary values - all inputs 4'hF, select in0");
            in0 = 4'hF;
            in1 = 4'hF;
            in2 = 4'hF;
            in3 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Boundary values - all inputs 4'h0, select in3");
            in0 = 4'h0;
            in1 = 4'h0;
            in2 = 4'h0;
            in3 = 4'h0;
            sel = 2'b11;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Walking bit pattern - select in1");
            in0 = 4'b0001;
            in1 = 4'b0010;
            in2 = 4'b0100;
            in3 = 4'b1000;
            sel = 2'b01;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Walking bit pattern - select in2");
            in0 = 4'b0001;
            in1 = 4'b0010;
            in2 = 4'b0100;
            in3 = 4'b1000;
            sel = 2'b10;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1_4bit Testbench");
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
