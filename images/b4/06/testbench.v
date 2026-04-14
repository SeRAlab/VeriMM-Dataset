`timescale 1ns/1ps

module adder_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire CARRY;
    wire [7:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_8bit dut (
        .A(A),
        .B(B),
        .CARRY(CARRY),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 8'h00;
            B = 8'h00;
            $display("Test Case %0d: Zero addition (0 + 0)", test_num);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 8'h05;
            B = 8'h0A;
            $display("Test Case %0d: Simple addition without carry (5 + 10)", test_num);
            #1;

            check_outputs(1'b0, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'h00;
            $display("Test Case %0d: Identity addition (255 + 0)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'h01;
            $display("Test Case %0d: Maximum value plus one (Carry check)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 8'h80;
            B = 8'h80;
            $display("Test Case %0d: MSB addition resulting in carry (128 + 128)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 8'hFF;
            B = 8'hFF;
            $display("Test Case %0d: Maximum values addition (255 + 255)", test_num);
            #1;

            check_outputs(1'b1, 8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 8'h55;
            B = 8'hAA;
            $display("Test Case %0d: Alternating bits (0x55 + 0xAA)", test_num);
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 8'h12;
            B = 8'h34;
            $display("Test Case %0d: Arbitrary addition (0x12 + 0x34)", test_num);
            #1;

            check_outputs(1'b0, 8'h46);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 8'hC0;
            B = 8'h40;
            $display("Test Case %0d: Boundary carry (192 + 64)", test_num);
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 8'h7F;
            B = 8'h01;
            $display("Test Case %0d: Transition from 127 to 128", test_num);
            #1;

            check_outputs(1'b0, 8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_8bit Testbench");
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
        input expected_CARRY;
        input [7:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CARRY === (expected_CARRY ^ CARRY ^ expected_CARRY) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: CARRY=%b, SUM=%h",
                         CARRY, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CARRY=%b, SUM=%h",
                         expected_CARRY, expected_SUM);
                $display("  Got:      CARRY=%b, SUM=%h",
                         CARRY, SUM);
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
