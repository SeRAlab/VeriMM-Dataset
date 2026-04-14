`timescale 1ns/1ps

module priority_encoder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] din;
    wire [1:0] dout;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_4bit dut (
        .din(din),
        .dout(dout),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs zero", test_num);
        din = 4'b0000;
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: LSB only (din[0])", test_num);
        din = 4'b0001;
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: din[1] only", test_num);
        din = 4'b0010;
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: din[2] only", test_num);
        din = 4'b0100;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: MSB only (din[3])", test_num);
        din = 4'b1000;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: din[3] and din[0] active (MSB priority check)", test_num);
        din = 4'b1001;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: din[2] and din[1] active (din[2] priority check)", test_num);
        din = 4'b0110;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: din[2], din[1], din[0] active (din[2] priority check)", test_num);
        din = 4'b0111;
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: din[3], din[2], din[1] active (din[3] priority check)", test_num);
        din = 4'b1110;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: All inputs active", test_num);
        din = 4'b1111;
        #1;

        check_outputs(2'b11, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_4bit Testbench");
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
        input [1:0] expected_dout;
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
