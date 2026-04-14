`timescale 1ns/1ps

module barrel_shifter_8bit_tb;

    // Testbench signals (combinational circuit)
    reg direction;
    reg [7:0] in;
    reg [2:0] shift;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_8bit dut (
        .direction(direction),
        .in(in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Shift Left by 0 (No shift)", test_num);
        in = 8'hA5;
        shift = 3'd0;
        direction = 1'b0;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Shift Right by 0 (No shift)", test_num);
        in = 8'hA5;
        shift = 3'd0;
        direction = 1'b1;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Shift Left by 1", test_num);
        in = 8'b10110011;
        shift = 3'd1;
        direction = 1'b0;
        #1;

        check_outputs(8'b01100110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Shift Right by 1", test_num);
        in = 8'b10110011;
        shift = 3'd1;
        direction = 1'b1;
        #1;

        check_outputs(8'b01011001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Shift Left by 4 (Mid-range)", test_num);
        in = 8'hFF;
        shift = 3'd4;
        direction = 1'b0;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Shift Right by 4 (Mid-range)", test_num);
        in = 8'hFF;
        shift = 3'd4;
        direction = 1'b1;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Shift Left by 7 (Max shift)", test_num);
        in = 8'hFF;
        shift = 3'd7;
        direction = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Shift Right by 7 (Max shift)", test_num);
        in = 8'hFF;
        shift = 3'd7;
        direction = 1'b1;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Clear all bits via Left Shift", test_num);
        in = 8'h01;
        shift = 3'd7;
        direction = 1'b0;
        #1;

        check_outputs(8'h80);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Pattern check Left/Right symmetry", test_num);
        in = 8'hC3;
        shift = 3'd2;
        direction = 1'b0;


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
        $display("barrel_shifter_8bit Testbench");
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
        input [7:0] expected_out;
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
