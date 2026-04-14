`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] op;
    wire br;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .op(op),
        .br(br)
    );
    task testcase001;

        begin
            $display("Running testcase001: Equality (EQ) and Inequality (NE)");

            A = 32'hAAAA_BBBB; B = 32'hAAAA_BBBB; op = 4'b0000;
            #1;

            check_outputs(1'b1);


            A = 32'hAAAA_BBBB; B = 32'hAAAA_CCCC; op = 4'b0000;
            #1;

            check_outputs(1'b0);


            A = 32'h1234_5678; B = 32'h8765_4321; op = 4'b0001;
            #1;

            check_outputs(1'b1);


            A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; op = 4'b0001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Signed Less Than (SLT) and Signed Greater or Equal (SGE)");

            A = 32'hFFFF_FFFF; B = 32'h0000_0001; op = 4'b0010;
            #1;

            check_outputs(1'b1);


            A = 32'h0000_0001; B = 32'hFFFF_FFFF; op = 4'b0010;
            #1;

            check_outputs(1'b0);


            A = 32'hFFFF_FFFF; B = 32'hFFFF_FFFF; op = 4'b0011;
            #1;

            check_outputs(1'b1);


            A = 32'hFFFF_FFFE; B = 32'hFFFF_FFFF; op = 4'b0011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Unsigned Less Than (ULT) and Unsigned Greater or Equal (UGE)");

            A = 32'hFFFF_FFFF; B = 32'h0000_0001; op = 4'b0100;
            #1;

            check_outputs(1'b0);


            A = 32'h0000_0001; B = 32'hFFFF_FFFF; op = 4'b0100;
            #1;

            check_outputs(1'b1);


            A = 32'hFFFF_FFFF; B = 32'h0000_0000; op = 4'b0101;
            #1;

            check_outputs(1'b1);


            A = 32'h0000_0000; B = 32'h0000_0001; op = 4'b0101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Signed Greater Than (SGT) and Signed Less or Equal (SLE)");

            A = 32'd5; B = -32'd5; op = 4'b0110;
            #1;

            check_outputs(1'b1);


            A = -32'd10; B = -32'd5; op = 4'b0110;
            #1;

            check_outputs(1'b0);


            A = -32'd10; B = -32'd5; op = 4'b0111;
            #1;

            check_outputs(1'b1);


            A = 32'd0; B = 32'd0; op = 4'b0111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Values (Max/Min)");

            A = 32'h8000_0000; B = 32'h7FFF_FFFF;


            op = 4'b0010;
            #1;

            check_outputs(1'b1);


            op = 4'b0100;
            #1;

            check_outputs(1'b0);


            A = 32'h0000_0000; B = 32'hFFFF_FFFF;


            op = 4'b0100;
            #1;

            check_outputs(1'b1);


            op = 4'b0101;
            #1;

            check_outputs(1'b0);
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
        input expected_br;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_br === (expected_br ^ br ^ expected_br)) begin
                $display("PASS");
                $display("  Outputs: br=%b",
                         br);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: br=%b",
                         expected_br);
                $display("  Got:      br=%b",
                         br);
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
