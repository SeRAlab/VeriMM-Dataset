`timescale 1ns/1ps

module and_gate_with_enable_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [3:0] in1;
    reg [3:0] in2;
    reg [3:0] in3;
    reg [3:0] in4;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_gate_with_enable dut (
        .en(en),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .out(out)
    );
    task set_inputs;

        input _en;
        input [3:0] _in1;
        input [3:0] _in2;
        input [3:0] _in3;
        input [3:0] _in4;
        begin
            test_num = test_num + 1;
            en = _en;
            in1 = _in1;
            in2 = _in2;
            in3 = _in3;
            in4 = _in4;
            $display("\nTest Case %0d:", test_num);
            $display("  Inputs: en=%b, in1=%h, in2=%h, in3=%h, in4=%h", _en, _in1, _in2, _in3, _in4);
        end
        endtask

    task testcase001;

        begin
            set_inputs(1'b0, 4'hF, 4'hF, 4'hF, 4'hF);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            set_inputs(1'b1, 4'hF, 4'hF, 4'hF, 4'hF);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            set_inputs(1'b1, 4'h0, 4'hF, 4'hF, 4'hF);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            set_inputs(1'b1, 4'hF, 4'h0, 4'hF, 4'hF);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            set_inputs(1'b1, 4'hF, 4'hF, 4'h0, 4'hF);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            set_inputs(1'b1, 4'hF, 4'hF, 4'hF, 4'h0);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            set_inputs(1'b1, 4'h1, 4'h2, 4'h4, 4'h8);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            set_inputs(1'b0, 4'h0, 4'h0, 4'h0, 4'h0);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            set_inputs(1'b1, 4'hA, 4'h5, 4'h3, 4'hC);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            set_inputs(1'b0, 4'hA, 4'h5, 4'h3, 4'hC);
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
        $display("and_gate_with_enable Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
