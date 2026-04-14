`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'hAA;
        B = 8'hF0;
        control = 3'b000;
        $display("Test %0d: AND - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'h55;
        B = 8'h0F;
        control = 3'b001;
        $display("Test %0d: OR - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'h12;
        B = 8'h34;
        control = 3'b010;
        $display("Test %0d: ADD - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h46);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'h50;
        B = 8'h20;
        control = 3'b011;
        $display("Test %0d: SUB - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'hFF;
        B = 8'hAA;
        control = 3'b100;
        $display("Test %0d: XOR - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'hFF;
        B = 8'h01;
        control = 3'b010;
        $display("Test %0d: ADD Overflow - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'h05;
        B = 8'h06;
        control = 3'b011;
        $display("Test %0d: SUB Negative Result - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'hFF;
        B = 8'h00;
        control = 3'b000;
        $display("Test %0d: AND with Zero - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'hC3;
        B = 8'hC3;
        control = 3'b100;
        $display("Test %0d: XOR same values - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'hF0;
        B = 8'h0F;
        control = 3'b001;
        $display("Test %0d: OR Result FF - A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
