`timescale 1ns/1ps

module kogge_stone_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [5:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    kogge_stone_adder dut (
        .A(A),
        .B(B),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        A = 5'd0;
        B = 5'd0;
        #10;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All Ones (Max Sum)", test_num);
        A = 5'd31;
        B = 5'd31;
        #10;
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Carry out to MSB (31 + 1)", test_num);
        A = 5'd31;
        B = 5'd1;
        #10;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Partial Carry (15 + 1)", test_num);
        A = 5'd15;
        B = 5'd1;
        #10;
        #1;

        check_outputs(6'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Interleaved bits (10101 + 01010)", test_num);
        A = 5'b10101;
        B = 5'b01010;
        #10;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: MSB addition (16 + 16)", test_num);
        A = 5'd16;
        B = 5'd16;
        #10;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Zero plus Max (0 + 31)", test_num);
        A = 5'd0;
        B = 5'd31;
        #10;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Small values (5 + 7)", test_num);
        A = 5'd5;
        B = 5'd7;
        #10;
        #1;

        check_outputs(6'd12);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Middle stage carry (7 + 9)", test_num);
        A = 5'd7;
        B = 5'd9;
        #10;
        #1;

        check_outputs(6'd16);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Arbitrary Large (27 + 13)", test_num);
        A = 5'd27;
        B = 5'd13;
        #10;
        #1;

        check_outputs(6'd40);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("kogge_stone_adder Testbench");
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
        input [5:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
