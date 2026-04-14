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
        $display("Testcase 001: Select D0 with D[0]=1");
        D = 8'b00000001; S = 3'd0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Select D1 with D[1]=1");
        D = 8'b00000010; S = 3'd1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Select D2 with D[2]=1");
        D = 8'b00000100; S = 3'd2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Select D3 with D[3]=1");
        D = 8'b00001000; S = 3'd3;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Select D4 with D[4]=1");
        D = 8'b00010000; S = 3'd4;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Select D5 with D[5]=1");
        D = 8'b00100000; S = 3'd5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Select D6 with D[6]=1");
        D = 8'b01000000; S = 3'd6;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Select D7 with D[7]=1");
        D = 8'b10000000; S = 3'd7;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Select D3 with D[3]=0 (All others 1)");
        D = 8'b11110111; S = 3'd3;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Select D5 with D[5]=0 (All others 1)");
        D = 8'b11011111; S = 3'd5;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Select D0 with D[0]=0 (All others 1)");
        D = 8'b11111110; S = 3'd0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase012;

    begin
        $display("Testcase 012: Select D7 with D[7]=0 (All others 1)");
        D = 8'b01111111; S = 3'd7;
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
