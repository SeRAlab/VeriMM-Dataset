`timescale 1ns/1ps

module decoder3to8_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg enable;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder3to8 dut (
        .a(a),
        .enable(enable),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        enable = 0;
        a = 3'b000;
        $display("Testcase %0d: Enable=0, Input=000", test_num);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        enable = 0;
        a = 3'b101;
        $display("Testcase %0d: Enable=0, Input=101", test_num);
        #1;

        check_outputs(8'b00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        enable = 1;
        a = 3'b000;
        $display("Testcase %0d: Enable=1, Input=000 (y[0] should be high)", test_num);
        #1;

        check_outputs(8'b00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        enable = 1;
        a = 3'b001;
        $display("Testcase %0d: Enable=1, Input=001 (y[1] should be high)", test_num);
        #1;

        check_outputs(8'b00000010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        enable = 1;
        a = 3'b010;
        $display("Testcase %0d: Enable=1, Input=010 (y[2] should be high)", test_num);
        #1;

        check_outputs(8'b00000100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        enable = 1;
        a = 3'b011;
        $display("Testcase %0d: Enable=1, Input=011 (y[3] should be high)", test_num);
        #1;

        check_outputs(8'b00001000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        enable = 1;
        a = 3'b100;
        $display("Testcase %0d: Enable=1, Input=100 (y[4] should be high)", test_num);
        #1;

        check_outputs(8'b00010000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        enable = 1;
        a = 3'b101;
        $display("Testcase %0d: Enable=1, Input=101 (y[5] should be high)", test_num);
        #1;

        check_outputs(8'b00100000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        enable = 1;
        a = 3'b110;
        $display("Testcase %0d: Enable=1, Input=110 (y[6] should be high)", test_num);
        #1;

        check_outputs(8'b01000000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        enable = 1;
        a = 3'b111;
        $display("Testcase %0d: Enable=1, Input=111 (y[7] should be high)", test_num);
        #1;

        check_outputs(8'b10000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder3to8 Testbench");
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
