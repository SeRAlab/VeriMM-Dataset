`timescale 1ns/1ps

module mux_2to1_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in0;
    reg [3:0] in1;
    reg sel;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_2to1_4bit dut (
        .in0(in0),
        .in1(in1),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: sel=0, in0=4'hA, in1=4'h5");
            sel = 1'b0;
            in0 = 4'hA;
            in1 = 4'h5;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: sel=1, in0=4'hA, in1=4'h5");
            sel = 1'b1;
            in0 = 4'hA;
            in1 = 4'h5;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: sel=0, in0=4'h0, in1=4'hF");
            sel = 1'b0;
            in0 = 4'h0;
            in1 = 4'hF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: sel=1, in0=4'h0, in1=4'hF");
            sel = 1'b1;
            in0 = 4'h0;
            in1 = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: sel=0, in0=4'b1100, in1=4'b0011");
            sel = 1'b0;
            in0 = 4'b1100;
            in1 = 4'b0011;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: sel=1, in0=4'b1100, in1=4'b0011");
            sel = 1'b1;
            in0 = 4'b1100;
            in1 = 4'b0011;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_2to1_4bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
