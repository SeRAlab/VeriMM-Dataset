`timescale 1ns/1ps

module KoggeStoneAdder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [5:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KoggeStoneAdder dut (
        .A(A),
        .B(B),
        .S(S)
    );
    task testcase001;

    begin
        $display("Testcase 001: 0 + 0");
        A = 5'd0;
        B = 5'd0;
        #1;

        check_outputs(6'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Max value addition (31 + 31)");
        A = 5'd31;
        B = 5'd31;
        #1;

        check_outputs(6'd62);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Simple carry propagation (15 + 1)");
        A = 5'd15;
        B = 5'd1;
        #1;

        check_outputs(6'd16);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: All bits set to zero vs one");
        A = 5'b00000;
        B = 5'b11111;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Carry out bit test (16 + 16)");
        A = 5'd16;
        B = 5'd16;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Alternating bits");
        A = 5'b10101;
        B = 5'b01010;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Random values 1 (12 + 19)");
        A = 5'd12;
        B = 5'd19;
        #1;

        check_outputs(6'd31);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Boundary test (31 + 1)");
        A = 5'd31;
        B = 5'd1;
        #1;

        check_outputs(6'd32);
    end
        endtask

    task testcase009;

    begin
        $display("Testcase 009: Random values 2 (7 + 8)");
        A = 5'd7;
        B = 5'd8;
        #1;

        check_outputs(6'd15);
    end
        endtask

    task testcase010;

    begin
        $display("Testcase 010: Power of 2 (4 + 4)");
        A = 5'd4;
        B = 5'd4;
        #1;

        check_outputs(6'd8);
    end
        endtask

    task testcase011;

    begin
        $display("Testcase 011: Full carry chain (31 + 31)");
        A = 5'b11111;
        B = 5'b11111;
        #1;

        check_outputs(6'b111110);
    end
        endtask

    task testcase012;

    begin
        $display("Testcase 012: Minimal values (1 + 1)");
        A = 5'd1;
        B = 5'd1;
        #1;

        check_outputs(6'd2);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KoggeStoneAdder Testbench");
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
        input [5:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
