`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg direction;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

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
        test_num = 1;
        data_in = 4'b1010;
        direction = 1'b0;
        shift_amount = 2'b00;
        $display("Testcase %0d: Left shift by 0 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 4'b1010;
        direction = 1'b0;
        shift_amount = 2'b01;
        $display("Testcase %0d: Left shift by 1 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 4'b1010;
        direction = 1'b0;
        shift_amount = 2'b10;
        $display("Testcase %0d: Left shift by 2 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 4'b1010;
        direction = 1'b0;
        shift_amount = 2'b11;
        $display("Testcase %0d: Left shift by 3 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 4'b1010;
        direction = 1'b1;
        shift_amount = 2'b00;
        $display("Testcase %0d: Right shift by 0 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 4'b1010;
        direction = 1'b1;
        shift_amount = 2'b01;
        $display("Testcase %0d: Right shift by 1 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 4'b1010;
        direction = 1'b1;
        shift_amount = 2'b10;
        $display("Testcase %0d: Right shift by 2 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 4'b1010;
        direction = 1'b1;
        shift_amount = 2'b11;
        $display("Testcase %0d: Right shift by 3 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 4'b1111;
        direction = 1'b0;
        shift_amount = 2'b01;
        $display("Testcase %0d: All ones left shift by 1 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 4'b1111;
        direction = 1'b1;
        shift_amount = 2'b10;
        $display("Testcase %0d: All ones right shift by 2 (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        data_in = 4'b0001;
        direction = 1'b1;
        shift_amount = 2'b01;
        $display("Testcase %0d: LSB right shift (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        data_in = 4'b1000;
        direction = 1'b0;
        shift_amount = 2'b01;
        $display("Testcase %0d: MSB left shift (Data: %b)", test_num, data_in);
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_data_out;
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
