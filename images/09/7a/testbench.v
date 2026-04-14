`timescale 1ns/1ps

module priority_encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8to3 dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: No inputs active");
            in = 8'b0000_0000;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Only input 0 active");
            in = 8'b0000_0001;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Only input 1 active");
            in = 8'b0000_0010;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Only input 2 active");
            in = 8'b0000_0100;
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Only input 3 active");
            in = 8'b0000_1000;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Only input 4 active");
            in = 8'b0001_0000;
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Only input 5 active");
            in = 8'b0010_0000;
            #1;

            check_outputs(3'b101);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Only input 6 active");
            in = 8'b0100_0000;
            #1;

            check_outputs(3'b110);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Only input 7 active");
            in = 8'b1000_0000;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Priority check - 7 and 0 active");
            in = 8'b1000_0001;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Priority check - 3, 2, 1 active");
            in = 8'b0000_1110;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Priority check - All inputs active");
            in = 8'b1111_1111;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase013;

        begin
            $display("Testcase 013: Priority check - Even bits active (6, 4, 2, 0)");
            in = 8'b0101_0101;
            #1;

            check_outputs(3'b110);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8to3 Testbench");
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
        testcase013();
        
        
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
        input [2:0] expected_out;
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
