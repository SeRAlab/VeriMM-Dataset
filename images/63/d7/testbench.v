`timescale 1ns/1ps

module priority_encoder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    wire [2:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8bit dut (
        .din(din),
        .dout(dout),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All inputs zero", test_num);
        din = 8'b00000000;
        #1;

        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Highest priority bit (din[7]) only", test_num);
        din = 8'b10000000;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Lowest priority bit (din[0]) only", test_num);
        din = 8'b00000001;
        #1;

        check_outputs(3'd0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Multiple bits set, check MSB priority (din=8'hFF)", test_num);
        din = 8'b11111111;
        #1;

        check_outputs(3'd7, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Bit 4 dominance (din=8'b00011111)", test_num);
        din = 8'b00011111;
        #1;

        check_outputs(3'd4, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Bit 1 dominance (din=8'b00000011)", test_num);
        din = 8'b00000011;
        #1;

        check_outputs(3'd1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Sparse bits (din=8'b01000100)", test_num);
        din = 8'b01000100;
        #1;

        check_outputs(3'd6, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [2:0] expected_dout;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, valid=%b",
                         dout, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, valid=%b",
                         expected_dout, expected_valid);
                $display("  Got:      dout=%h, valid=%b",
                         dout, valid);
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
