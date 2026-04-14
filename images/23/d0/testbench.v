`timescale 1ns/1ps

module ALU_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [2:0] ALU_control;
    reg [15:0] B;
    wire [15:0] ALU_result;
    wire comparison_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU_16bit dut (
        .A(A),
        .ALU_control(ALU_control),
        .B(B),
        .ALU_result(ALU_result),
        .comparison_flag(comparison_flag)
    );
    task set_inputs;

        input [15:0] a_val;
        input [15:0] b_val;
        input [2:0] ctrl;
        begin
            A = a_val;
            B = b_val;
            ALU_control = ctrl;
            test_num = test_num + 1;
            $display("Test %0d: Op=%b A=%h B=%h", test_num, ctrl, a_val, b_val);
        end
        endtask

    task testcase001;

        begin
            set_inputs(16'h1234, 16'h1111, 3'b000);
            #1;

            check_outputs(16'h2345, 0);
        end
        endtask

    task testcase002;

        begin
            set_inputs(16'hFFFF, 16'h0001, 3'b000);
            #1;

            check_outputs(16'h0000, 0);
        end
        endtask

    task testcase003;

        begin
            set_inputs(16'h0020, 16'h0005, 3'b001);
            #1;

            check_outputs(16'h001B, 0);
        end
        endtask

    task testcase004;

        begin
            set_inputs(16'h0005, 16'h0006, 3'b001);
            #1;

            check_outputs(16'hFFFF, 0);
        end
        endtask

    task testcase005;

        begin
            set_inputs(16'hAAAA, 16'hF0F0, 3'b010);
            #1;

            check_outputs(16'hA0A0, 0);
        end
        endtask

    task testcase006;

        begin
            set_inputs(16'hAAAA, 16'h5555, 3'b011);
            #1;

            check_outputs(16'hFFFF, 0);
        end
        endtask

    task testcase007;

        begin
            set_inputs(16'hFFFF, 16'h1234, 3'b100);
            #1;

            check_outputs(16'hEDCB, 0);
        end
        endtask

    task testcase008;

        begin
            set_inputs(16'h0001, 16'h0004, 3'b101);
            #1;

            check_outputs(16'h0010, 0);
        end
        endtask

    task testcase009;

        begin
            set_inputs(16'h8000, 16'h0004, 3'b110);
            #1;

            check_outputs(16'h0800, 0);
        end
        endtask

    task testcase010;

        begin
            set_inputs(16'h0005, 16'h000A, 3'b111);
            #1;

            check_outputs(16'h0001, 1);
        end
        endtask

    task testcase011;

        begin
            set_inputs(16'h000A, 16'h000A, 3'b111);
            #1;

            check_outputs(16'h0000, 0);
        end
        endtask

    task testcase012;

        begin
            set_inputs(16'h00FF, 16'h0001, 3'b111);
            #1;

            check_outputs(16'h0000, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ALU_16bit Testbench");
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
        testcase012();
        
        
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
        input [15:0] expected_ALU_result;
        input expected_comparison_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ALU_result === (expected_ALU_result ^ ALU_result ^ expected_ALU_result) &&
                expected_comparison_flag === (expected_comparison_flag ^ comparison_flag ^ expected_comparison_flag)) begin
                $display("PASS");
                $display("  Outputs: ALU_result=%h, comparison_flag=%b",
                         ALU_result, comparison_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ALU_result=%h, comparison_flag=%b",
                         expected_ALU_result, expected_comparison_flag);
                $display("  Got:      ALU_result=%h, comparison_flag=%b",
                         ALU_result, comparison_flag);
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
