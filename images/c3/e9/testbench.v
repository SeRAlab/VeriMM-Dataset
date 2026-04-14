`timescale 1ns/1ps

module adder8_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire C;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder8 dut (
        .A(A),
        .B(B),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero addition (0 + 0)", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple addition without carry (10 + 5)", test_num);
            A = 8'd10;
            B = 8'd5;
            #1;

            check_outputs(1'b0, 8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Max value without carry (250 + 5)", test_num);
            A = 8'd250;
            B = 8'd5;
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Boundary carry trigger (255 + 1)", test_num);
            A = 8'd255;
            B = 8'd1;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Carry trigger from MSB (128 + 128)", test_num);
            A = 8'd128;
            B = 8'd128;
            #1;

            check_outputs(1'b1, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Maximum possible values (255 + 255)", test_num);
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(1'b1, 8'd254);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Bit pattern addition (0xAA + 0x55)", test_num);
            A = 8'hAA;
            B = 8'h55;
            #1;

            check_outputs(1'b0, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Random addition (123 + 45)", test_num);
            A = 8'd123;
            B = 8'd45;
            #1;

            check_outputs(1'b0, 8'd168);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Carry propagation check (0xFF + 0x01)", test_num);
            A = 8'hFF;
            B = 8'h01;
            #1;

            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Low nibble carry to high nibble (0x0F + 0x01)", test_num);
            A = 8'h0F;
            B = 8'h01;
            #1;

            check_outputs(1'b0, 8'h10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder8 Testbench");
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
        input expected_C;
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%b, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%b, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%b, S=%h",
                         C, S);
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
