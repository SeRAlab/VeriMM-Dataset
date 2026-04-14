`timescale 1ns/1ps

module mux_3to1_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] in0;
    reg [5:0] in1;
    reg [5:0] in2;
    reg [1:0] sel;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_3to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in0", test_num);
            sel = 2'b00;
            in0 = 6'h3F;
            in1 = 6'h00;
            in2 = 6'h00;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in1", test_num);
            sel = 2'b01;
            in0 = 6'h00;
            in1 = 6'h2A;
            in2 = 6'h00;
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select in2", test_num);
            sel = 2'b10;
            in0 = 6'h00;
            in1 = 6'h00;
            in2 = 6'h15;
            #1;

            check_outputs(6'h15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs active, select in0", test_num);
            sel = 2'b00;
            in0 = 6'h0F;
            in1 = 6'h33;
            in2 = 6'h11;
            #1;

            check_outputs(6'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs active, select in1", test_num);
            sel = 2'b01;
            in0 = 6'h0F;
            in1 = 6'h33;
            in2 = 6'h11;
            #1;

            check_outputs(6'h33);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs active, select in2", test_num);
            sel = 2'b10;
            in0 = 6'h0F;
            in1 = 6'h33;
            in2 = 6'h11;
            #1;

            check_outputs(6'h11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero value check on in1", test_num);
            sel = 2'b01;
            in0 = 6'h3F;
            in1 = 6'h00;
            in2 = 6'h3F;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value check on in2", test_num);
            sel = 2'b10;
            in0 = 6'h00;
            in1 = 6'h00;
            in2 = 6'h3F;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_3to1 Testbench");
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
        input [5:0] expected_out;
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
