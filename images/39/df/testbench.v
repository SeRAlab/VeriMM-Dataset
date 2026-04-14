`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg direction;
    reg [2:0] shift_amount;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .direction(direction),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift by 0 positions", test_num);
            data_in = 8'b10101010;
            direction = 1'b0;
            shift_amount = 3'd0;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift by 1 position", test_num);
            data_in = 8'b00000001;
            direction = 1'b0;
            shift_amount = 3'd1;
            #1;

            check_outputs(8'b00000010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift by 4 positions", test_num);
            data_in = 8'b00001111;
            direction = 1'b0;
            shift_amount = 3'd4;
            #1;

            check_outputs(8'b11110000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift by 7 positions (Max)", test_num);
            data_in = 8'b00000001;
            direction = 1'b0;
            shift_amount = 3'd7;
            #1;

            check_outputs(8'b10000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift by 0 positions", test_num);
            data_in = 8'b10101010;
            direction = 1'b1;
            shift_amount = 3'd0;
            #1;

            check_outputs(8'b10101010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift by 1 position", test_num);
            data_in = 8'b10000000;
            direction = 1'b1;
            shift_amount = 3'd1;
            #1;

            check_outputs(8'b01000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift by 4 positions", test_num);
            data_in = 8'b11110000;
            direction = 1'b1;
            shift_amount = 3'd4;
            #1;

            check_outputs(8'b00001111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift by 7 positions (Max)", test_num);
            data_in = 8'b10000000;
            direction = 1'b1;
            shift_amount = 3'd7;
            #1;

            check_outputs(8'b00000001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift with data overflow (zero fill check)", test_num);
            data_in = 8'b11001101;
            direction = 1'b0;
            shift_amount = 3'd3;
            #1;

            check_outputs(8'b01101000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift with data overflow (zero fill check)", test_num);
            data_in = 8'b11001101;
            direction = 1'b1;
            shift_amount = 3'd3;
            #1;

            check_outputs(8'b00011001);
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
        input [7:0] expected_data_out;
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
