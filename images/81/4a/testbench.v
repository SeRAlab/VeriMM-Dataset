`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] data;
    reg direction;
    reg [2:0] shift_amount;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data(data),
        .direction(direction),
        .shift_amount(shift_amount),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: No shift (Left, amount 0)", test_num);
            data = 6'b101101;
            shift_amount = 3'd0;
            direction = 1'b0;
            #1;

            check_outputs(6'b101101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Left shift by 1", test_num);
            data = 6'b100000;
            shift_amount = 3'd1;
            direction = 1'b0;

            #1;


            check_outputs(6'b000001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Right shift by 1", test_num);
            data = 6'b000001;
            shift_amount = 3'd1;
            direction = 1'b1;

            #1;


            check_outputs(6'b100000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Left shift by 2", test_num);
            data = 6'b110000;
            shift_amount = 3'd2;
            direction = 1'b0;

            #1;


            check_outputs(6'b000011);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Right shift by 2", test_num);
            data = 6'b000011;
            shift_amount = 3'd2;
            direction = 1'b1;

            #1;


            check_outputs(6'b110000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Shift by half-width (3 bits)", test_num);
            data = 6'b101010;
            shift_amount = 3'd3;
            direction = 1'b0;

            #1;


            check_outputs(6'b010101);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Data with all bits set", test_num);
            data = 6'b111111;
            shift_amount = 3'd4;
            direction = 1'b1;
            #1;

            check_outputs(6'b111111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Shift amount exceeding width (6 mod 6 = 0)", test_num);
            data = 6'b010011;
            shift_amount = 3'd6;
            direction = 1'b0;
            #1;

            check_outputs(6'b010011);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest %0d: Shift amount exceeding width (7 mod 6 = 1)", test_num);
            data = 6'b010011;
            shift_amount = 3'd7;
            direction = 1'b0;

            #1;


            check_outputs(6'b100110);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest %0d: Complex pattern rotation", test_num);
            data = 6'b110111;
            shift_amount = 3'd5;
            direction = 1'b1;


            #1;



            check_outputs(6'b101111);
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
        input [5:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
