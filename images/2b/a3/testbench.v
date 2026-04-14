`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] control;
    wire [7:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .control(control),
        .Z(Z)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Basic)", test_num);
        A = 8'h0A; B = 8'h05; control = 3'b000;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition (Overflow/Wrap)", test_num);
        A = 8'hFF; B = 8'h01; control = 3'b000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Basic)", test_num);
        A = 8'h14; B = 8'h04; control = 3'b001;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Subtraction (Underflow/Wrap)", test_num);
        A = 8'h00; B = 8'h01; control = 3'b001;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise AND", test_num);
        A = 8'hAA; B = 8'hF0; control = 3'b010;
        #1;

        check_outputs(8'hA0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise OR", test_num);
        A = 8'h55; B = 8'h0F; control = 3'b011;
        #1;

        check_outputs(8'h5F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bitwise XOR", test_num);
        A = 8'hFF; B = 8'hAA; control = 3'b100;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison (A > B is True)", test_num);
        A = 8'h20; B = 8'h10; control = 3'b101;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison (A > B is False - Less)", test_num);
        A = 8'h05; B = 8'h10; control = 3'b101;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Comparison (A > B is False - Equal)", test_num);
        A = 8'h77; B = 8'h77; control = 3'b101;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
