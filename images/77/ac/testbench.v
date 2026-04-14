`timescale 1ns/1ps

module barrel_shifter_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [3:0] shift_amount;
    reg shift_dir;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_16bit dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .shift_dir(shift_dir),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = 1;
            data_in = 16'hABCD;
            shift_amount = 4'd0;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift by 0", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data_in = 16'hABCD;
            shift_amount = 4'd0;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift by 0", test_num);
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data_in = 16'h0001;
            shift_amount = 4'd1;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift by 1 (0x0001 << 1)", test_num);
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data_in = 16'h8000;
            shift_amount = 4'd1;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift by 1 (0x8000 >> 1)", test_num);
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data_in = 16'h000F;
            shift_amount = 4'd4;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift by 4 (0x000F << 4)", test_num);
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data_in = 16'hF000;
            shift_amount = 4'd4;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift by 4 (0xF000 >> 4)", test_num);
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data_in = 16'h00FF;
            shift_amount = 4'd8;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift by 8 (0x00FF << 8)", test_num);
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data_in = 16'hFF00;
            shift_amount = 4'd8;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift by 8 (0xFF00 >> 8)", test_num);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data_in = 16'h0001;
            shift_amount = 4'd15;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift by 15 (Max)", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data_in = 16'h8000;
            shift_amount = 4'd15;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift by 15 (Max)", test_num);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            data_in = 16'hFFFF;
            shift_amount = 4'd12;
            shift_dir = 1'b0;
            $display("Test %0d: Left shift 12 bits out of 0xFFFF", test_num);
            #1;

            check_outputs(16'hF000);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            data_in = 16'hFFFF;
            shift_amount = 4'd12;
            shift_dir = 1'b1;
            $display("Test %0d: Right shift 12 bits out of 0xFFFF", test_num);
            #1;

            check_outputs(16'h000F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter_16bit Testbench");
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
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
