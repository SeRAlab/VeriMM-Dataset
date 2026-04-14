`timescale 1ns/1ps

module priority_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] S;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder dut (
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        S = 5'b00000;
        $display("Test %0d: No sources active (S=00000)", test_num);
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        S = 5'b00001;
        $display("Test %0d: Only S0 active (S=00001)", test_num);
        #1;

        check_outputs(3'b001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        S = 5'b00010;
        $display("Test %0d: Only S1 active (S=00010)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        S = 5'b00100;
        $display("Test %0d: Only S2 active (S=00100)", test_num);
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        S = 5'b01000;
        $display("Test %0d: Only S3 active (S=01000)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        S = 5'b10000;
        $display("Test %0d: Only S4 active (S=10000)", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        S = 5'b10001;
        $display("Test %0d: S4 and S0 active (S=10001)", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        S = 5'b01110;
        $display("Test %0d: S3, S2, and S1 active (S=01110)", test_num);
        #1;

        check_outputs(3'b100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        S = 5'b00011;
        $display("Test %0d: S1 and S0 active (S=00011)", test_num);
        #1;

        check_outputs(3'b010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        S = 5'b11111;
        $display("Test %0d: All sources active (S=11111)", test_num);
        #1;

        check_outputs(3'b101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder Testbench");
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
        input [2:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
