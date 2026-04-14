`timescale 1ns/1ps

module multiplexer_8bit_8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    reg [7:0] in2;
    reg [7:0] in3;
    reg [7:0] in4;
    reg [7:0] in5;
    reg [7:0] in6;
    reg [7:0] in7;
    reg [2:0] sel;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplexer_8bit_8to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel(sel),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select input 0", test_num);
            in0 = 8'hA1; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b000;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select input 1", test_num);
            in0 = 8'h00; in1 = 8'hB2; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b001;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select input 2", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'hC3; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b010;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select input 3", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'hD4;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b011;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Select input 4", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'hE5; in5 = 8'h00; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b100;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Select input 5", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'hF6; in6 = 8'h00; in7 = 8'h00;
            sel = 3'b101;
            #1;

            check_outputs(8'hF6);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Select input 6", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h17; in7 = 8'h00;
            sel = 3'b110;
            #1;

            check_outputs(8'h17);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Select input 7", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h00; in3 = 8'h00;
            in4 = 8'h00; in5 = 8'h00; in6 = 8'h00; in7 = 8'h28;
            sel = 3'b111;
            #1;

            check_outputs(8'h28);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Verify all inputs with 0xFF", test_num);
            in0 = 8'hFF; in1 = 8'hFF; in2 = 8'hFF; in3 = 8'hFF;
            in4 = 8'hFF; in5 = 8'hFF; in6 = 8'hFF; in7 = 8'hFF;
            sel = 3'b100;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Verify input change while selected", test_num);
            in0 = 8'h00; in1 = 8'h00; in2 = 8'h55; in3 = 8'h00;
            sel = 3'b010;
            #5;
            in2 = 8'hAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplexer_8bit_8to1 Testbench");
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
        input [7:0] expected_out;
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
