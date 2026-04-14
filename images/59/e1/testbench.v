`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] choose;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [31:0] in4;
    reg [31:0] in5;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .choose(choose),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in1 (choose = 000)", test_num);
            in1 = 32'hDEADBEEF; in2 = 32'h11111111; in3 = 32'h22222222;
            in4 = 32'h33333333; in5 = 32'h44444444;
            choose = 3'b000;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in2 (choose = 001)", test_num);
            in1 = 32'hAAAAAAAA; in2 = 32'hCAFEBABE; in3 = 32'hBBBBBBBB;
            in4 = 32'hCCCCCCCC; in5 = 32'hDDDDDDDD;
            choose = 3'b001;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in3 (choose = 010)", test_num);
            in1 = 32'h0; in2 = 32'h0; in3 = 32'hFFFFFFFF;
            in4 = 32'h0; in5 = 32'h0;
            choose = 3'b010;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in4 (choose = 011)", test_num);
            in1 = 32'h12345678; in2 = 32'h87654321; in3 = 32'hABCDEF01;
            in4 = 32'h55AA55AA; in5 = 32'hAA55AA55;
            choose = 3'b011;
            #1;

            check_outputs(32'h55AA55AA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select in5 (choose = 100)", test_num);
            in1 = 32'h1; in2 = 32'h2; in3 = 32'h3;
            in4 = 32'h4; in5 = 32'hBADC0DE1;
            choose = 3'b100;
            #1;

            check_outputs(32'hBADC0DE1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid selection (choose = 101)", test_num);
            in1 = 32'hFFFFFFFF; in2 = 32'hFFFFFFFF; in3 = 32'hFFFFFFFF;
            in4 = 32'hFFFFFFFF; in5 = 32'hFFFFFFFF;
            choose = 3'b101;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid selection (choose = 110)", test_num);
            in1 = 32'h12341234; in5 = 32'h43214321;
            choose = 3'b110;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Invalid selection (choose = 111)", test_num);
            in1 = 32'hAAAAAAAA; in2 = 32'hBBBBBBBB; in3 = 32'hCCCCCCCC;
            in4 = 32'hDDDDDDDD; in5 = 32'hEEEEEEEE;
            choose = 3'b111;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary check - all inputs zero, valid choose", test_num);
            in1 = 0; in2 = 0; in3 = 0; in4 = 0; in5 = 0;
            choose = 3'b010;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Rapid input change check", test_num);
            in1 = 32'h00000001;
            choose = 3'b000;
            #2;
            in1 = 32'h00000002;
            #1;

            check_outputs(32'h00000002);
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
        input [31:0] expected_out;
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
