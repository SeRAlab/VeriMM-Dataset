`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_i;
    reg [2:0] shift_i;
    wire [2:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_i(data_i),
        .shift_i(shift_i),
        .data_o(data_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd0;
            #10;
            $display("Test %0d: Shift Left 0 (Expect bits 7:5 of input)", test_num);
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd1;
            #10;
            $display("Test %0d: Shift Left 1 (Expect bits 6:4 of input)", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd2;
            #10;
            $display("Test %0d: Shift Left 2 (Expect bits 5:3 of input)", test_num);
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd3;
            #10;
            $display("Test %0d: Shift Left 3 (Expect bits 4:2 of input)", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd4;
            #10;
            $display("Test %0d: Shift Left 4 (Expect bits 3:1 of input)", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd5;
            #10;
            $display("Test %0d: Shift Left 5 (Expect bits 2:0 of input)", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd6;
            #10;
            $display("Test %0d: Shift Left 6 (Expect {bit 1, bit 0, 0})", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            data_i = 8'b10110010;
            shift_i = 3'd7;
            #10;
            $display("Test %0d: Shift Left 7 (Expect {bit 0, 0, 0})", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            data_i = 8'hFF;
            shift_i = 3'd7;
            #10;
            $display("Test %0d: All ones input, shift 7", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            data_i = 8'h00;
            shift_i = 3'd4;
            #10;
            $display("Test %0d: All zeros input, shift 4", test_num);
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_data_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
