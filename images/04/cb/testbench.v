`timescale 1ns/1ps

module barrel_shifter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    reg mode;
    reg [2:0] shift_amt;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter dut (
        .data_in(data_in),
        .mode(mode),
        .shift_amt(shift_amt),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 8'hAA;
        mode = 1'b0;
        shift_amt = 3'd0;
        $display("Test %0d: Left Shift by 0 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 8'hAA;
        mode = 1'b0;
        shift_amt = 3'd1;
        $display("Test %0d: Left Shift by 1 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h54);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 8'h0F;
        mode = 1'b0;
        shift_amt = 3'd4;
        $display("Test %0d: Left Shift by 4 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 8'hFF;
        mode = 1'b0;
        shift_amt = 3'd7;
        $display("Test %0d: Left Shift by 7 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 8'h55;
        mode = 1'b1;
        shift_amt = 3'd0;
        $display("Test %0d: Right Shift by 0 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 8'hAA;
        mode = 1'b1;
        shift_amt = 3'd1;
        $display("Test %0d: Right Shift by 1 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 8'hF0;
        mode = 1'b1;
        shift_amt = 3'd4;
        $display("Test %0d: Right Shift by 4 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 8'hFF;
        mode = 1'b1;
        shift_amt = 3'd7;
        $display("Test %0d: Right Shift by 7 (Data: %h)", test_num, data_in);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 8'h00;
        mode = 1'b0;
        shift_amt = 3'd3;
        $display("Test %0d: Left Shift All Zeros", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 8'h01;
        mode = 1'b1;
        shift_amt = 3'd2;
        $display("Test %0d: Right Shift out LSB (Data: 01)", test_num);
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
