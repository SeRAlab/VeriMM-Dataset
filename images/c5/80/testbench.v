`timescale 1ns/1ps

module binary_converter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] input_num;
    wire [7:0] binary_num;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_converter dut (
        .input_num(input_num),
        .binary_num(binary_num)
    );
    task testcase001;

        begin
            test_num = 1;
            input_num = 4'b0000;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input_num = 4'b1111;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input_num = 4'b1010;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input_num = 4'b0101;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input_num = 4'b1000;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input_num = 4'b0001;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            input_num = 4'b0111;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h07);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            input_num = 4'b1100;
            $display("Test %0d: Input = %b", test_num, input_num);
            #1;

            check_outputs(8'h0C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_converter Testbench");
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
        input [7:0] expected_binary_num;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_binary_num === (expected_binary_num ^ binary_num ^ expected_binary_num)) begin
                $display("PASS");
                $display("  Outputs: binary_num=%h",
                         binary_num);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: binary_num=%h",
                         expected_binary_num);
                $display("  Got:      binary_num=%h",
                         binary_num);
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
