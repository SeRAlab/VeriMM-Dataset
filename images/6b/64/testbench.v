`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg C_IN;
    reg D_IN;
    reg NEG;
    reg [2:0] OP;
    wire C_OUT;
    wire [7:0] R;
    wire V_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C_IN(C_IN),
        .D_IN(D_IN),
        .NEG(NEG),
        .OP(OP),
        .C_OUT(C_OUT),
        .R(R),
        .V_OUT(V_OUT)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd10; B = 8'd20; OP = 3'b000; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'd30, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'hFF; B = 8'h01; OP = 3'b000; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b1, 8'h00, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd50; B = 8'd20; OP = 3'b000; NEG = 1; C_IN = 1; D_IN = 0;
        #1;

        check_outputs(1'b1, 8'd30, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'h7F; B = 8'h01; OP = 3'b000; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'h80, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'b10101010; B = 8'b11110000; OP = 3'b001; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'b10100000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'b10101010; B = 8'b01010101; OP = 3'b010; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'b11111111, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'hFF; B = 8'hAA; OP = 3'b011; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'h55, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'h81; B = 8'h00; OP = 3'b100; NEG = 0; C_IN = 0; D_IN = 1;
        #1;

        check_outputs(1'b1, 8'h03, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'h81; B = 8'h00; OP = 3'b101; NEG = 0; C_IN = 0; D_IN = 1;
        #1;

        check_outputs(1'b1, 8'hC0, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'h81; B = 8'h00; OP = 3'b110; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'h03, 1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        A = 8'h81; B = 8'h00; OP = 3'b111; NEG = 0; C_IN = 0; D_IN = 0;
        #1;

        check_outputs(1'b0, 8'hC0, 1'b0);
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
        testcase011();
        
        
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
        input expected_C_OUT;
        input [7:0] expected_R;
        input expected_V_OUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_OUT === (expected_C_OUT ^ C_OUT ^ expected_C_OUT) &&
                expected_R === (expected_R ^ R ^ expected_R) &&
                expected_V_OUT === (expected_V_OUT ^ V_OUT ^ expected_V_OUT)) begin
                $display("PASS");
                $display("  Outputs: C_OUT=%b, R=%h, V_OUT=%b",
                         C_OUT, R, V_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_OUT=%b, R=%h, V_OUT=%b",
                         expected_C_OUT, expected_R, expected_V_OUT);
                $display("  Got:      C_OUT=%b, R=%h, V_OUT=%b",
                         C_OUT, R, V_OUT);
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
