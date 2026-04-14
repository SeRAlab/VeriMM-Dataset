`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg [1:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        $display("Test Case 001: Select D0, D0 is 0");
        S = 2'b00;
        D = 4'b1110;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Select D0, D0 is 1");
        S = 2'b00;
        D = 4'b0001;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Select D1, D1 is 0");
        S = 2'b01;
        D = 4'b1101;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Select D1, D1 is 1");
        S = 2'b01;
        D = 4'b0010;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Select D2, D2 is 0");
        S = 2'b10;
        D = 4'b1011;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Select D2, D2 is 1");
        S = 2'b10;
        D = 4'b0100;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Select D3, D3 is 0");
        S = 2'b11;
        D = 4'b0111;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Select D3, D3 is 1");
        S = 2'b11;
        D = 4'b1000;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: All inputs high");
        S = 2'b10;
        D = 4'b1111;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: All inputs low");
        S = 2'b01;
        D = 4'b0000;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
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
