`timescale 1ns/1ps

module mux8to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] D;
    reg [2:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux8to1 dut (
        .D(D),
        .S(S),
        .Y(Y)
    );
    task testcase001;

    begin
        $display("Test Case 001: Selecting D0");
        S = 3'b000;
        D = 8'b00000001;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Selecting D1");
        S = 3'b001;
        D = 8'b00000010;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Selecting D2");
        S = 3'b010;
        D = 8'b00000100;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Selecting D3");
        S = 3'b011;
        D = 8'b00001000;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Selecting D4");
        S = 3'b100;
        D = 8'b00010000;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Selecting D5");
        S = 3'b101;
        D = 8'b00100000;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Selecting D6");
        S = 3'b110;
        D = 8'b01000000;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Selecting D7");
        S = 3'b111;
        D = 8'b10000000;
        #1;

        check_outputs(1'b1);
        D = 8'b00000000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        $display("Test Case 009: Interference Check (D0 selected, others toggle)");
        S = 3'b000;
        D = 8'b11111110;
        #1;

        check_outputs(1'b0);
        D = 8'b00000001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        $display("Test Case 010: All inputs high");
        D = 8'b11111111;
        S = 3'b000; #1;
 check_outputs(1'b1);
        S = 3'b011; #1;
 check_outputs(1'b1);
        S = 3'b111; #1;
 check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux8to1 Testbench");
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
