`timescale 1ns/1ps

module mux2to1_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg sel;
    wire [4:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux2to1 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: sel=0, a=5'h0A, b=5'h15", test_num);
            a = 5'h0A;
            b = 5'h15;
            sel = 1'b0;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: sel=1, a=5'h0A, b=5'h15", test_num);
            a = 5'h0A;
            b = 5'h15;
            sel = 1'b1;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: sel=0, a=5'h1F, b=5'h00", test_num);
            a = 5'h1F;
            b = 5'h00;
            sel = 1'b0;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: sel=1, a=5'h1F, b=5'h00", test_num);
            a = 5'h1F;
            b = 5'h00;
            sel = 1'b1;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: sel=0, a=5'h00, b=5'h1F", test_num);
            a = 5'h00;
            b = 5'h1F;
            sel = 1'b0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: sel=1, a=5'h00, b=5'h1F", test_num);
            a = 5'h00;
            b = 5'h1F;
            sel = 1'b1;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: sel=0, a=5'h11, b=5'h11", test_num);
            a = 5'h11;
            b = 5'h11;
            sel = 1'b0;
            #1;

            check_outputs(5'h11);
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
        input [4:0] expected_out;
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
