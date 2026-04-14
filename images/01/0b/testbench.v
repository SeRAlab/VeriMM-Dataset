`timescale 1ns/1ps

module ALU_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg [2:0] ctrl;
    wire comp;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ALU dut (
        .A(A),
        .B(B),
        .ctrl(ctrl),
        .comp(comp),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition (15 + 27)", test_num);
            A = 8'd15;
            B = 8'd27;
            ctrl = 3'b000;
            #1;

            check_outputs(1'b0, 8'd42);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction (100 - 36)", test_num);
            A = 8'd100;
            B = 8'd36;
            ctrl = 3'b001;
            #1;

            check_outputs(1'b0, 8'd64);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise AND (0xF0 & 0xCC)", test_num);
            A = 8'hF0;
            B = 8'hCC;
            ctrl = 3'b010;
            #1;

            check_outputs(1'b0, 8'hC0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise OR (0xA0 | 0x05)", test_num);
            A = 8'hA0;
            B = 8'h05;
            ctrl = 3'b011;
            #1;

            check_outputs(1'b0, 8'hA5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bitwise XOR (0xAA ^ 0x55)", test_num);
            A = 8'hAA;
            B = 8'h55;
            ctrl = 3'b100;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison (5 < 10)", test_num);
            A = 8'd5;
            B = 8'd10;
            ctrl = 3'b101;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Comparison (10 < 5)", test_num);
            A = 8'd10;
            B = 8'd5;
            ctrl = 3'b101;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Left (0x01 << 1)", test_num);
            A = 8'h01;
            B = 8'h00;
            ctrl = 3'b110;
            #1;

            check_outputs(1'b0, 8'h02);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Shift Right (0x80 >> 1)", test_num);
            A = 8'h80;
            B = 8'h00;
            ctrl = 3'b111;
            #1;

            check_outputs(1'b0, 8'h40);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition Overflow (255 + 1)", test_num);
            A = 8'hFF;
            B = 8'h01;
            ctrl = 3'b000;
            #1;

            check_outputs(1'b0, 8'h00);
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
        input expected_comp;
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp === (expected_comp ^ comp ^ expected_comp) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: comp=%b, result=%h",
                         comp, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp=%b, result=%h",
                         expected_comp, expected_result);
                $display("  Got:      comp=%b, result=%h",
                         comp, result);
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
