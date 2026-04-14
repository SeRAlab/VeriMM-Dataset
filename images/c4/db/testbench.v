`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] DATA;
    reg [2:0] SHIFT_AMOUNT;
    reg SHIFT_DIRECTION;
    wire [7:0] SHIFTED_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .DATA(DATA),
        .SHIFT_AMOUNT(SHIFT_AMOUNT),
        .SHIFT_DIRECTION(SHIFT_DIRECTION),
        .SHIFTED_DATA(SHIFTED_DATA)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 0 (No shift)", test_num);
            DATA = 8'hA5;
            SHIFT_AMOUNT = 3'd0;
            SHIFT_DIRECTION = 1'b0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 0 (No shift)", test_num);
            DATA = 8'h5A;
            SHIFT_AMOUNT = 3'd0;
            SHIFT_DIRECTION = 1'b1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 1", test_num);
            DATA = 8'b00000001;
            SHIFT_AMOUNT = 3'd1;
            SHIFT_DIRECTION = 1'b0;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 4", test_num);
            DATA = 8'h0F;
            SHIFT_AMOUNT = 3'd4;
            SHIFT_DIRECTION = 1'b0;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift by 7 (Maximum)", test_num);
            DATA = 8'h01;
            SHIFT_AMOUNT = 3'd7;
            SHIFT_DIRECTION = 1'b0;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 1", test_num);
            DATA = 8'b10000000;
            SHIFT_AMOUNT = 3'd1;
            SHIFT_DIRECTION = 1'b1;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 4", test_num);
            DATA = 8'hF0;
            SHIFT_AMOUNT = 3'd4;
            SHIFT_DIRECTION = 1'b1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift by 7 (Maximum)", test_num);
            DATA = 8'h80;
            SHIFT_AMOUNT = 3'd7;
            SHIFT_DIRECTION = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift clearing bits", test_num);
            DATA = 8'hFF;
            SHIFT_AMOUNT = 3'd3;
            SHIFT_DIRECTION = 1'b0;
            #1;

            check_outputs(8'hF8);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift clearing bits", test_num);
            DATA = 8'hFF;
            SHIFT_AMOUNT = 3'd5;
            SHIFT_DIRECTION = 1'b1;
            #1;

            check_outputs(8'h07);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter Testbench");
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
        input [7:0] expected_SHIFTED_DATA;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SHIFTED_DATA === (expected_SHIFTED_DATA ^ SHIFTED_DATA ^ expected_SHIFTED_DATA)) begin
                $display("PASS");
                $display("  Outputs: SHIFTED_DATA=%h",
                         SHIFTED_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SHIFTED_DATA=%h",
                         expected_SHIFTED_DATA);
                $display("  Got:      SHIFTED_DATA=%h",
                         SHIFTED_DATA);
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
