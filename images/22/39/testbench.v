`timescale 1ns/1ps

module ALU_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire C_out;
    wire [7:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_8bit dut (
        .A(A),
        .B(B),
        .control(control),
        .C_out(C_out),
        .R(R)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: AND - 8'hAA & 8'hF0", test_num);
        A = 8'hAA; B = 8'hF0; control = 3'b000;
        #1;

        check_outputs(1'b0, 8'hA0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: OR - 8'h55 | 8'h0F", test_num);
        A = 8'h55; B = 8'h0F; control = 3'b001;
        #1;

        check_outputs(1'b0, 8'h5F);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD - 8'h10 + 8'h20", test_num);
        A = 8'h10; B = 8'h20; control = 3'b010;
        #1;

        check_outputs(1'b0, 8'h30);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: ADD - 8'hFF + 8'h01", test_num);
        A = 8'hFF; B = 8'h01; control = 3'b010;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUBTRACT - 8'h10 - 8'h05", test_num);
        A = 8'h10; B = 8'h05; control = 3'b011;
        #1;

        check_outputs(1'b0, 8'h0B);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SUBTRACT - 8'h00 - 8'h01", test_num);
        A = 8'h00; B = 8'h01; control = 3'b011;

        #1;


        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: XOR - 8'hFF ^ 8'hAA", test_num);
        A = 8'hFF; B = 8'hAA; control = 3'b100;
        #1;

        check_outputs(1'b0, 8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: NOT - ~8'h0F", test_num);
        A = 8'h0F; B = 8'h00; control = 3'b101;
        #1;

        check_outputs(1'b0, 8'hF0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SHIFT LEFT - 8'h01 << 1", test_num);
        A = 8'h01; B = 8'h00; control = 3'b110;
        #1;

        check_outputs(1'b0, 8'h02);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: SHIFT RIGHT - 8'h80 >> 1", test_num);
        A = 8'h80; B = 8'h00; control = 3'b111;
        #1;

        check_outputs(1'b0, 8'h40);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_8bit Testbench");
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
        input expected_C_out;
        input [7:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, R=%h",
                         C_out, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, R=%h",
                         expected_C_out, expected_R);
                $display("  Got:      C_out=%b, R=%h",
                         C_out, R);
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
